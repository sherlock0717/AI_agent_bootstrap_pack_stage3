from __future__ import annotations

import argparse
import json
import re
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import yaml


SGT = timezone(timedelta(hours=8))


def now_iso() -> str:
    return datetime.now(SGT).isoformat(timespec="seconds")


def read_json(path: Path, default: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    if not path.exists():
        return default or {}
    try:
        with path.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return default or {}


def write_json(path: Path, data: Dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def append_log(path: Path, message: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(f"{now_iso()} {message}\n")


def read_yaml(path: Path) -> Dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"未找到 YAML 文件：{path}")
    with path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    if not isinstance(data, dict):
        raise ValueError(f"YAML 结构不是 dict：{path}")
    return data


def relative_to_root(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except Exception:
        return path.as_posix()


def resolve_path(raw_path: str, system_root: Path, external_projects_root: Path) -> Path:
    raw = (raw_path or "").replace("\\", "/").strip()
    if not raw:
        return Path("")

    p = Path(raw)
    if p.is_absolute():
        return p

    if raw.startswith("projects/"):
        return external_projects_root / Path(raw[len("projects/"):])

    return system_root / Path(raw)


def find_task(manifest: Dict[str, Any], task_id: str) -> Dict[str, Any]:
    tasks = manifest.get("tasks", [])
    if not isinstance(tasks, list):
        raise ValueError("task_manifest.yaml 中缺少 tasks 列表。")

    for task in tasks:
        if isinstance(task, dict) and str(task.get("task_id")) == str(task_id):
            return task

    raise ValueError(f"未找到任务：{task_id}")


def extract_latest_run_id(system_root: Path, project_name: str, task_id: str) -> str:
    runtime_path = system_root / "outputs" / "runtime" / project_name / "task_runtime_state.json"
    state = read_json(runtime_path, default={})
    tasks = state.get("tasks", {})
    if not isinstance(tasks, dict):
        raise ValueError("task_runtime_state.json 结构异常。")

    info = tasks.get(task_id)
    if not isinstance(info, dict):
        raise ValueError(f"runtime_state 中未找到任务：{task_id}")

    run_id = str(info.get("last_run_id", "")).strip()
    if not run_id:
        raise ValueError(f"任务 {task_id} 当前没有 last_run_id，无法执行 reviewer。")
    return run_id


def read_artifact_text(path: Path) -> str:
    suffix = path.suffix.lower()

    if suffix in {".md", ".txt", ".py", ".ps1", ".json", ".yaml", ".yml"}:
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except Exception as e:
            return f"[读取失败] {e}"

        if suffix == ".json":
            try:
                data = json.loads(text)
                return json.dumps(data, ensure_ascii=False, indent=2)
            except Exception:
                return text

        if suffix in {".yaml", ".yml"}:
            try:
                data = yaml.safe_load(text)
                return json.dumps(data, ensure_ascii=False, indent=2)
            except Exception:
                return text

        return text

    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        return f"[暂不支持该文件类型，读取失败] {e}"


def compute_metrics(text: str) -> Dict[str, Any]:
    stripped = text.strip()
    lines = text.splitlines()

    heading_count = sum(1 for line in lines if line.strip().startswith("#"))
    bullet_count = sum(
        1 for line in lines
        if line.strip().startswith("- ")
        or line.strip().startswith("* ")
        or re.match(r"^\d+\.\s+", line.strip())
    )
    chinese_count = sum(1 for ch in text if "\u4e00" <= ch <= "\u9fff")
    paragraph_count = sum(1 for line in lines if line.strip())
    char_count = len(stripped)

    return {
        "char_count": char_count,
        "heading_count": heading_count,
        "bullet_count": bullet_count,
        "chinese_count": chinese_count,
        "paragraph_count": paragraph_count,
        "is_empty": char_count == 0,
    }


def keyword_expectations(task_type: str) -> List[str]:
    mapping = {
        "ai_analysis_task": ["分析", "摘要", "建议", "说明"],
        "ai_generation_task": ["草案", "设定", "核心", "方向"],
        "ai_planning_task": ["路线", "计划", "阶段", "建议"],
        "ai_integration_task": ["整合", "汇总", "说明", "下一步"],
    }
    return mapping.get(task_type, ["说明", "内容"])


def reviewer_threshold(profile: str) -> int:
    profile = (profile or "standard").strip().lower()
    if profile == "strict":
        return 75
    if profile == "publish_level":
        return 85
    return 65


def grade_artifact(
    task_type: str,
    text: str,
    metrics: Dict[str, Any],
    profile: str,
) -> Dict[str, Any]:
    strengths: List[str] = []
    issues: List[str] = []
    critical_issues: List[str] = []
    score = 0

    char_count = int(metrics.get("char_count", 0))
    heading_count = int(metrics.get("heading_count", 0))
    bullet_count = int(metrics.get("bullet_count", 0))
    chinese_count = int(metrics.get("chinese_count", 0))
    paragraph_count = int(metrics.get("paragraph_count", 0))

    if char_count == 0:
        critical_issues.append("文件内容为空。")
    else:
        score += 20
        strengths.append("文件成功生成且可读取。")

    if char_count >= 300:
        score += 20
        strengths.append("文本长度达到基础要求。")
    elif char_count >= 120:
        score += 10
        issues.append("文本长度基本够用，但内容仍偏短。")
    else:
        critical_issues.append("文本长度过短，当前不足以支撑后续使用。")

    if heading_count >= 2:
        score += 15
        strengths.append("结构化标题较完整。")
    else:
        issues.append("标题结构较少，内容组织仍可加强。")

    if bullet_count >= 2:
        score += 10
        strengths.append("包含列表或分点，便于阅读。")
    else:
        issues.append("分点表达较少，阅读友好性一般。")

    if chinese_count > 0:
        score += 10
        strengths.append("输出符合当前中文项目环境。")
    else:
        issues.append("文本中几乎没有中文，可能不适合当前项目直接使用。")

    if paragraph_count >= 4:
        score += 10
        strengths.append("段落层次基本清楚。")
    else:
        issues.append("段落层次偏少，内容展开不够。")

    expected_keywords = keyword_expectations(task_type)
    hits = [kw for kw in expected_keywords if kw in text]
    if hits:
        score += 15
        strengths.append(f"包含与任务类型相关的关键词：{', '.join(hits[:4])}。")
    else:
        issues.append(f"缺少与任务类型相关的明显关键词：{', '.join(expected_keywords)}。")

    threshold = reviewer_threshold(profile)

    if critical_issues:
        decision = "fail"
    elif score >= threshold and len(issues) <= 2:
        decision = "pass"
    elif score >= 50:
        decision = "revise"
    else:
        decision = "fail"

    return {
        "decision": decision,
        "score": score,
        "threshold": threshold,
        "strengths": strengths,
        "issues": issues,
        "critical_issues": critical_issues,
    }


def build_review_markdown(
    project_name: str,
    task: Dict[str, Any],
    run_id: str,
    reviewer_profile: str,
    review_data: Dict[str, Any],
) -> str:
    overall = review_data["overall_decision"]
    artifacts = review_data["artifacts_reviewed"]

    lines: List[str] = [
        f"# Reviewer 结果：{task.get('task_name', task.get('task_id', ''))}",
        "",
        "## 总体结论",
        f"- 项目名称：{project_name}",
        f"- 任务 ID：{task.get('task_id', '')}",
        f"- Run ID：{run_id}",
        f"- Reviewer Profile：{reviewer_profile}",
        f"- 总体结论：{overall}",
        f"- 建议动作：{review_data.get('recommended_next_action', '')}",
        f"- 审核时间：{review_data.get('reviewed_at', '')}",
        "",
        "## 总体说明",
        review_data.get("summary", ""),
        "",
    ]

    for idx, item in enumerate(artifacts, start=1):
        lines += [
            f"## 产物 {idx}",
            f"- 路径：{item.get('artifact_path', '')}",
            f"- 是否存在：{item.get('exists', False)}",
            f"- 字符数：{item.get('metrics', {}).get('char_count', 0)}",
            f"- 标题数：{item.get('metrics', {}).get('heading_count', 0)}",
            f"- 分点数：{item.get('metrics', {}).get('bullet_count', 0)}",
            f"- 结论：{item.get('review', {}).get('decision', '')}",
            f"- 分数：{item.get('review', {}).get('score', 0)} / {item.get('review', {}).get('threshold', 0)}",
            "",
            "### 优点",
        ]

        strengths = item.get("review", {}).get("strengths", [])
        if strengths:
            lines += [f"- {s}" for s in strengths]
        else:
            lines.append("- 暂无明显优点记录。")

        lines += ["", "### 问题"]

        issues = item.get("review", {}).get("issues", [])
        critical = item.get("review", {}).get("critical_issues", [])
        if issues or critical:
            lines += [f"- {x}" for x in critical]
            lines += [f"- {x}" for x in issues]
        else:
            lines.append("- 当前未发现明显问题。")

        lines.append("")

    lines += [
        "## 下一步建议",
        f"- {review_data.get('recommended_next_action', '')}",
        "",
        "## 说明",
        "- 本 reviewer 第一版为确定性审核器，主要检查结构、长度、关键词与可读性。",
        "- 后续可替换为 DeepSeek 驱动的更强审核器。",
    ]

    return "\n".join(lines) + "\n"


def ensure_pending_human_action(
    system_root: Path,
    project_name: str,
    task_id: str,
    run_id: str,
    decision: str,
    review_json_rel: str,
) -> None:
    inbox_path = system_root / "outputs" / "inbox" / "pending_human_actions.json"
    data = read_json(inbox_path, default={"items": []})
    items = data.get("items", [])
    if not isinstance(items, list):
        items = []

    action_id = f"review_{project_name}_{task_id}_{run_id}"

    for item in items:
        if isinstance(item, dict) and item.get("action_id") == action_id:
            return

    items.append({
        "action_id": action_id,
        "project_name": project_name,
        "source_type": "review",
        "source_ref": review_json_rel,
        "title": f"请处理 reviewer 结果：{task_id}",
        "recommended_options": ["accept_review", "revise_output"],
        "status": "open",
        "decision": decision,
        "created_at": now_iso(),
    })

    data["items"] = items
    write_json(inbox_path, data)


def update_runtime_state(
    system_root: Path,
    project_name: str,
    task_id: str,
    status: str,
    run_id: str,
    review_status: str,
    review_json_rel: str,
    review_note_rel: str,
) -> None:
    runtime_path = system_root / "outputs" / "runtime" / project_name / "task_runtime_state.json"
    state = read_json(runtime_path, default={
        "project_name": project_name,
        "updated_at": now_iso(),
        "tasks": {},
    })

    tasks = state.setdefault("tasks", {})
    info = tasks.setdefault(task_id, {})
    info["status"] = status
    info["last_run_id"] = run_id
    info["review_status"] = review_status
    info["review_json"] = review_json_rel
    info["review_note"] = review_note_rel
    state["updated_at"] = now_iso()

    write_json(runtime_path, state)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--system-root", required=True)
    parser.add_argument("--external-projects-root", required=True)
    parser.add_argument("--project-name", required=True)
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--run-id", default="")
    parser.add_argument("--reviewer-profile", default="standard")
    args = parser.parse_args()

    system_root = Path(args.system_root).expanduser().resolve()
    external_projects_root = Path(args.external_projects_root).expanduser().resolve()
    project_name = args.project_name
    task_id = args.task_id
    reviewer_profile = args.reviewer_profile.strip() or "standard"

    run_id = args.run_id.strip()
    if not run_id:
        run_id = extract_latest_run_id(system_root, project_name, task_id)

    manifest_path = external_projects_root / project_name / "task_manifest.yaml"
    run_json_path = system_root / "outputs" / "runs" / project_name / f"{run_id}.json"
    log_path = system_root / "logs" / "runs" / project_name / f"{run_id}.log"
    review_json_path = system_root / "outputs" / "review" / project_name / f"{task_id}__{run_id}.json"
    review_note_path = system_root / "knowledge" / "projects" / project_name / "reviews" / f"{task_id}__{run_id}.md"

    append_log(log_path, f"[REVIEW_START] task={task_id} reviewer_profile={reviewer_profile}")

    manifest = read_yaml(manifest_path)
    task = find_task(manifest, task_id)
    run_record = read_json(run_json_path, default={})
    if not run_record:
        raise FileNotFoundError(f"未找到运行记录：{run_json_path}")

    artifact_paths_raw = run_record.get("artifacts", [])
    if isinstance(artifact_paths_raw, str):
        artifact_paths_raw = [artifact_paths_raw]
    if not isinstance(artifact_paths_raw, list):
        artifact_paths_raw = []

    if not artifact_paths_raw:
        fallback = task.get("expected_output", [])
        if isinstance(fallback, str):
            artifact_paths_raw = [fallback]
        elif isinstance(fallback, list):
            artifact_paths_raw = [str(x) for x in fallback if x]

    artifact_reviews: List[Dict[str, Any]] = []

    for raw in artifact_paths_raw:
        resolved = resolve_path(str(raw), system_root, external_projects_root)
        exists = resolved.exists()

        if exists:
            text = read_artifact_text(resolved)
            metrics = compute_metrics(text)
            review = grade_artifact(str(task.get("task_type", "")), text, metrics, reviewer_profile)
        else:
            metrics = {
                "char_count": 0,
                "heading_count": 0,
                "bullet_count": 0,
                "chinese_count": 0,
                "paragraph_count": 0,
                "is_empty": True,
            }
            review = {
                "decision": "fail",
                "score": 0,
                "threshold": reviewer_threshold(reviewer_profile),
                "strengths": [],
                "issues": [],
                "critical_issues": ["产物文件不存在，无法审核。"],
            }

        artifact_reviews.append({
            "artifact_path": relative_to_root(resolved, system_root),
            "exists": exists,
            "metrics": metrics,
            "review": review,
        })

    decisions = [item["review"]["decision"] for item in artifact_reviews]
    if "fail" in decisions:
        overall_decision = "fail"
        recommended_next_action = "请先处理严重问题，再重新执行该任务或人工修订后再审。"
    elif "revise" in decisions:
        overall_decision = "revise"
        recommended_next_action = "建议先补强当前产物内容，再重新提交审核。"
    else:
        overall_decision = "pass"
        recommended_next_action = "当前产物已通过第一版 reviewer，可进入下一步任务或人工确认。"

    summary_map = {
        "pass": "当前产物通过第一版 reviewer，结构和可读性基本满足继续推进要求。",
        "revise": "当前产物可以继续使用，但结构或信息完整性仍有待补强，建议先修订。",
        "fail": "当前产物未通过第一版 reviewer，存在明显缺失或严重问题，暂不建议继续推进。",
    }

    review_data = {
        "project_name": project_name,
        "task_id": task_id,
        "run_id": run_id,
        "reviewer_profile": reviewer_profile,
        "reviewed_at": now_iso(),
        "task_type": task.get("task_type", ""),
        "overall_decision": overall_decision,
        "summary": summary_map[overall_decision],
        "recommended_next_action": recommended_next_action,
        "artifacts_reviewed": artifact_reviews,
        "review_json_path": relative_to_root(review_json_path, system_root),
        "review_note_path": relative_to_root(review_note_path, system_root),
    }

    write_json(review_json_path, review_data)
    review_note_path.parent.mkdir(parents=True, exist_ok=True)
    review_note_path.write_text(
        build_review_markdown(project_name, task, run_id, reviewer_profile, review_data),
        encoding="utf-8",
    )

    run_record["review_status"] = overall_decision
    run_record["ai_decisions"] = run_record.get("ai_decisions", []) + [
        {
            "decision_type": "reviewer",
            "summary": f"Reviewer 第一版完成，结论：{overall_decision}",
            "detail": {
                "reviewer_profile": reviewer_profile,
                "review_json": relative_to_root(review_json_path, system_root),
                "review_note": relative_to_root(review_note_path, system_root),
            },
            "recorded_at": now_iso(),
        }
    ]
    write_json(run_json_path, run_record)

    if overall_decision == "pass":
        task_status = "done"
    else:
        task_status = "waiting_human_decision"
        ensure_pending_human_action(
            system_root=system_root,
            project_name=project_name,
            task_id=task_id,
            run_id=run_id,
            decision=overall_decision,
            review_json_rel=relative_to_root(review_json_path, system_root),
        )

    update_runtime_state(
        system_root=system_root,
        project_name=project_name,
        task_id=task_id,
        status=task_status,
        run_id=run_id,
        review_status=overall_decision,
        review_json_rel=relative_to_root(review_json_path, system_root),
        review_note_rel=relative_to_root(review_note_path, system_root),
    )

    append_log(log_path, f"[REVIEW_DONE] task={task_id} decision={overall_decision}")

    print(json.dumps({
        "ok": True,
        "project_name": project_name,
        "task_id": task_id,
        "run_id": run_id,
        "reviewer_profile": reviewer_profile,
        "overall_decision": overall_decision,
        "review_json": relative_to_root(review_json_path, system_root),
        "review_note": relative_to_root(review_note_path, system_root),
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
