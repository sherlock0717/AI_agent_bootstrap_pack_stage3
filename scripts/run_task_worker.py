from __future__ import annotations

import argparse
import json
import shutil
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any, Dict, List

import yaml


SGT = timezone(timedelta(hours=8))


def now_iso() -> str:
    return datetime.now(SGT).isoformat(timespec="seconds")


def now_stamp() -> str:
    return datetime.now(SGT).strftime("%Y%m%d_%H%M%S")


def build_run_id(task_id: str) -> str:
    safe = (task_id or "task").replace(" ", "_").replace("/", "_").replace("\\", "_").replace(":", "_")
    return f"run_{datetime.now(SGT).strftime('%Y%m%d_%H%M%S')}_{safe}"


def read_yaml(path: Path) -> Dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"未找到 YAML 文件：{path}")
    with path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    if not isinstance(data, dict):
        raise ValueError(f"YAML 结构不是 dict：{path}")
    return data


def read_json(path: Path, default: Dict[str, Any] | None = None) -> Dict[str, Any]:
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


def relative_to_root(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except Exception:
        return path.as_posix()


def find_task(manifest: Dict[str, Any], task_id: str) -> Dict[str, Any]:
    tasks = manifest.get("tasks", [])
    if not isinstance(tasks, list):
        raise ValueError("task_manifest.yaml 中缺少 tasks 列表。")
    for task in tasks:
        if isinstance(task, dict) and str(task.get("task_id")) == str(task_id):
            return task
    raise ValueError(f"未找到任务：{task_id}")


def normalize_output_candidates(task: Dict[str, Any], project_name: str) -> List[str]:
    raw: List[str] = []

    expected = task.get("expected_output", [])
    if isinstance(expected, str):
        raw.append(expected)
    elif isinstance(expected, list):
        raw.extend([str(x) for x in expected if x])

    artifacts = task.get("artifacts", [])
    if isinstance(artifacts, str):
        raw.append(artifacts)
    elif isinstance(artifacts, list):
        raw.extend([str(x) for x in artifacts if x])

    cleaned: List[str] = []
    for item in raw:
        item = item.replace("<ProjectName>", project_name).strip()
        if item and item not in cleaned:
            cleaned.append(item)

    return cleaned


def resolve_target_path(raw_path: str, system_root: Path, external_projects_root: Path) -> Path:
    raw = raw_path.replace("\\", "/").strip()

    if raw.startswith("projects/"):
        rel = raw[len("projects/"):]
        return external_projects_root / Path(rel)

    if raw.startswith("deliverables/") or raw.startswith("outputs/") or raw.startswith("logs/") or raw.startswith("knowledge/"):
        return system_root / Path(raw)

    return system_root / Path(raw)


def convert_target_if_needed(path: Path) -> Path:
    suffix = path.suffix.lower()

    if suffix in {".md", ".txt"}:
        return path

    if suffix in {".yaml", ".yml"}:
        return path.with_name(path.stem + "__generated_note.md")

    if suffix == "":
        return path.with_suffix(".md")

    return path.with_suffix(".md")


def backup_if_exists(path: Path) -> None:
    if path.exists():
        backup_name = f"{path.stem}.bak_{now_stamp()}{path.suffix}"
        backup_path = path.with_name(backup_name)
        shutil.copy2(path, backup_path)


def summarize_upstream(system_root: Path, project_name: str) -> List[str]:
    lines: List[str] = []

    intake_json = system_root / "outputs" / "intake" / project_name / "intake_analysis.json"
    blueprint_json = system_root / "outputs" / "intake" / project_name / "workflow_blueprint.json"
    brief_md = system_root / "deliverables" / "projects" / project_name / "brief" / "intake_brief.md"
    blueprint_md = system_root / "deliverables" / "projects" / project_name / "plan" / "workflow_blueprint.md"

    if intake_json.exists():
        data = read_json(intake_json, default={})
        keys = ", ".join(list(data.keys())[:10]) if data else "无可读键"
        lines.append(f"- intake_analysis.json 已存在，顶层键：{keys}")

    if blueprint_json.exists():
        data = read_json(blueprint_json, default={})
        keys = ", ".join(list(data.keys())[:10]) if data else "无可读键"
        lines.append(f"- workflow_blueprint.json 已存在，顶层键：{keys}")

    if brief_md.exists():
        lines.append(f"- intake_brief.md 已存在：{brief_md.as_posix()}")

    if blueprint_md.exists():
        lines.append(f"- workflow_blueprint.md 已存在：{blueprint_md.as_posix()}")

    if not lines:
        lines.append("- 当前未发现上游输入文件，本次按任务清单信息生成。")

    return lines


def render_markdown(
    project_name: str,
    task: Dict[str, Any],
    target_path: Path,
    system_root: Path,
) -> str:
    task_id = str(task.get("task_id", ""))
    task_name = str(task.get("task_name", ""))
    task_type = str(task.get("task_type", ""))
    owner = str(task.get("owner", ""))
    model_route = str(task.get("model_route", ""))
    description = str(task.get("description", ""))
    phase_id = str(task.get("phase_id", ""))
    need_gate = str(task.get("need_human_gate", ""))

    upstream_lines = summarize_upstream(system_root, project_name)

    body_lines: List[str] = [
        f"# {task_name}",
        "",
        "## 生成说明",
        f"- 项目名称：{project_name}",
        f"- 任务 ID：{task_id}",
        f"- 阶段：{phase_id}",
        f"- 任务类型：{task_type}",
        f"- Owner：{owner}",
        f"- 模型路由：{model_route}",
        f"- 人工 Gate：{need_gate or '无'}",
        f"- 生成时间：{now_iso()}",
        "",
        "## 任务描述",
        description or "无",
        "",
        "## 上游输入概况",
        *upstream_lines,
        "",
    ]

    if task_type == "ai_analysis_task":
        body_lines += [
            "## 分析摘要（初版）",
            "1. 该任务对应的是分析类工作，当前版本先按任务清单与已有上游文件生成结构化初稿。",
            "2. 输出重点放在：目标澄清、约束整理、当前可推进事项。",
            "3. 后续接入 DeepSeek 后，可在这一结构上替换为真实模型生成结果。",
            "",
            "## 当前建议",
            "- 先核对本稿是否覆盖项目当前阶段所需信息。",
            "- 若确认无误，可将本文件作为后续 Gate 或 reviewer 的输入之一。",
        ]
    elif task_type == "ai_generation_task":
        body_lines += [
            "## 生成草案（初版）",
            "### 核心设定",
            "- 待根据上游 brief 和 blueprint 进一步细化。",
            "",
            "### 可扩展方向",
            "- 可从世界观、角色、媒介路线三个方向扩展。",
            "",
            "### 当前备注",
            "- 当前版本为执行器生成的结构化草稿，用于打通真实任务执行链。",
        ]
    elif task_type == "ai_planning_task":
        body_lines += [
            "## 路线候选（初版）",
            "### 候选路线 A",
            "- 先做低成本内容验证，再进入扩展。",
            "",
            "### 候选路线 B",
            "- 先确定核心设定，再规划多媒介延展。",
            "",
            "### 建议",
            "- 先由人工选择路线，再进入下一阶段任务。",
        ]
    elif task_type == "ai_integration_task":
        body_lines += [
            "## 整合说明（初版）",
            "- 当前任务需要整合已有草案、建议与蓝图。",
            "- 本版本先生成结构化整合说明，避免直接覆盖系统关键 YAML 文件。",
            "",
            "## 后续动作",
            "- 建议在下一步接入 reviewer 与人工确认节点。",
        ]
    else:
        body_lines += [
            "## 输出内容",
            "- 当前任务类型尚未配置专用模板，已按通用结构生成初稿。",
        ]

    body_lines += [
        "",
        "## 输出路径",
        f"- {target_path.as_posix()}",
        "",
        "## 说明",
        "- 本文件由 `project_run_task.ps1 + run_task_worker.py` 第一版生成。",
        "- 当前版本是确定性执行器，不直接调用 DeepSeek。",
    ]

    return "\n".join(body_lines) + "\n"


def update_runtime_state(
    system_root: Path,
    project_name: str,
    task_id: str,
    run_id: str,
    status: str,
    artifacts: List[str],
    last_error: str | None,
) -> None:
    runtime_path = system_root / "outputs" / "runtime" / project_name / "task_runtime_state.json"
    state = read_json(runtime_path, default={
        "project_name": project_name,
        "updated_at": now_iso(),
        "tasks": {},
    })

    tasks = state.setdefault("tasks", {})
    tasks[task_id] = {
        "status": status,
        "last_run_id": run_id,
        "last_error": last_error,
        "artifacts": artifacts,
    }
    state["updated_at"] = now_iso()
    write_json(runtime_path, state)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--system-root", required=True)
    parser.add_argument("--external-projects-root", required=True)
    parser.add_argument("--project-name", required=True)
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--run-id", default="")
    parser.add_argument("--runner", default="project_run_task.ps1")
    args = parser.parse_args()

    system_root = Path(args.system_root).expanduser().resolve()
    external_projects_root = Path(args.external_projects_root).expanduser().resolve()
    project_name = args.project_name
    task_id = args.task_id
    run_id = args.run_id.strip() or build_run_id(task_id)

    manifest_path = external_projects_root / project_name / "task_manifest.yaml"

    run_json_path = system_root / "outputs" / "runs" / project_name / f"{run_id}.json"
    log_path = system_root / "logs" / "runs" / project_name / f"{run_id}.log"

    run_record = read_json(run_json_path, default={
        "run_id": run_id,
        "project_name": project_name,
        "task_id": task_id,
        "action_type": "execute_task",
        "runner": args.runner,
        "status": "running",
        "started_at": now_iso(),
        "ended_at": None,
        "logs_ref": relative_to_root(log_path, system_root),
        "artifacts": [],
        "ai_decisions": [],
        "needs_human_feedback": False,
        "review_status": None,
        "error_summary": None,
    })

    write_json(run_json_path, run_record)
    append_log(log_path, f"[START] project={project_name} task={task_id}")

    try:
        manifest = read_yaml(manifest_path)
        task = find_task(manifest, task_id)
        raw_outputs = normalize_output_candidates(task, project_name)

        if not raw_outputs:
            raw_outputs = [f"deliverables/projects/{project_name}/report/{task_id}__generated_output.md"]

        actual_artifacts: List[str] = []

        for raw_output in raw_outputs:
            resolved = resolve_target_path(raw_output, system_root, external_projects_root)
            actual_target = convert_target_if_needed(resolved)

            actual_target.parent.mkdir(parents=True, exist_ok=True)
            backup_if_exists(actual_target)

            content = render_markdown(project_name, task, actual_target, system_root)
            actual_target.write_text(content, encoding="utf-8")

            rel = relative_to_root(actual_target, system_root)
            actual_artifacts.append(rel)
            append_log(log_path, f"[WRITE] {actual_target.as_posix()}")

        run_record["status"] = "done"
        run_record["ended_at"] = now_iso()
        run_record["artifacts"] = actual_artifacts
        run_record["error_summary"] = None
        run_record["ai_decisions"] = run_record.get("ai_decisions", []) + [
            {
                "decision_type": "task_execution",
                "summary": "已按任务清单生成第一版真实产物。",
                "detail": {
                    "task_name": task.get("task_name", ""),
                    "task_type": task.get("task_type", ""),
                    "artifact_count": len(actual_artifacts),
                },
                "recorded_at": now_iso(),
            }
        ]

        write_json(run_json_path, run_record)
        update_runtime_state(
            system_root=system_root,
            project_name=project_name,
            task_id=task_id,
            run_id=run_id,
            status="done",
            artifacts=actual_artifacts,
            last_error=None,
        )
        append_log(log_path, f"[DONE] task={task_id} artifacts={len(actual_artifacts)}")

        print(json.dumps({
            "ok": True,
            "project_name": project_name,
            "task_id": task_id,
            "run_id": run_id,
            "artifacts": actual_artifacts,
            "run_record": relative_to_root(run_json_path, system_root),
            "log": relative_to_root(log_path, system_root),
        }, ensure_ascii=False))
        return 0

    except Exception as e:
        run_record["status"] = "failed"
        run_record["ended_at"] = now_iso()
        run_record["error_summary"] = str(e)
        write_json(run_json_path, run_record)

        update_runtime_state(
            system_root=system_root,
            project_name=project_name,
            task_id=task_id,
            run_id=run_id,
            status="failed",
            artifacts=[],
            last_error=str(e),
        )
        append_log(log_path, f"[FAILED] task={task_id} error={e}")

        print(json.dumps({
            "ok": False,
            "project_name": project_name,
            "task_id": task_id,
            "run_id": run_id,
            "error": str(e),
            "run_record": relative_to_root(run_json_path, system_root),
            "log": relative_to_root(log_path, system_root),
        }, ensure_ascii=False))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
