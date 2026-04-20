from __future__ import annotations

import argparse
import json
import os
import re
import urllib.request
from pathlib import Path
from typing import Any

TEXT_EXTENSIONS = {
    ".txt", ".md", ".json", ".yaml", ".yml", ".py", ".ps1", ".js", ".ts",
    ".tsx", ".jsx", ".html", ".css", ".csv", ".ini", ".toml"
}

ALLOWED_OWNERS = {"system", "user", "cursor", "gpt_manual"}
ALLOWED_MODEL_ROUTES = {"deepseek_reasoner", "deepseek_default", "gpt_manual", "cursor_code"}
ALLOWED_GATES = {"", "gate_0", "gate_1", "gate_2", "gate_3", "gate_4"}

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--system-root", required=True)
    parser.add_argument("--external-project-dir", required=False, default="")
    parser.add_argument("--project-name", required=True)
    parser.add_argument("--input-mode", required=True, choices=["idea_text", "file", "folder"])
    parser.add_argument("--input-path", required=True)
    parser.add_argument("--profile", default="default")
    return parser.parse_args()

def load_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")

def read_prompt(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")

def summarize_file(path: Path, max_chars: int = 1200) -> str:
    ext = path.suffix.lower()
    if ext not in TEXT_EXTENSIONS:
        return f"[binary_or_unsupported] {path.name}"
    try:
        text = load_text(path)
    except Exception as e:
        return f"[read_error] {path.name}: {e}"
    text = re.sub(r"\s+", " ", text).strip()
    return f"{path.name}: {text[:max_chars]}"

def collect_input_summary(input_mode: str, input_path: Path) -> tuple[str, list[str]]:
    if input_mode in {"idea_text", "file"}:
        summary = summarize_file(input_path, max_chars=2500)
        return summary, [input_path.name]

    inventory = []
    snippets = []
    for file in sorted(input_path.rglob("*")):
        if not file.is_file():
            continue
        rel = str(file.relative_to(input_path))
        inventory.append(rel)
        if file.suffix.lower() in TEXT_EXTENSIONS and len(snippets) < 12:
            snippets.append(summarize_file(file, max_chars=600))
    summary = "\n".join(snippets) if snippets else "(没有可读取的文本类文件摘要)"
    return summary, inventory

def auto_profile(project_name: str, summary: str, requested_profile: str) -> str:
    if requested_profile != "default":
        return requested_profile
    text = f"{project_name}\n{summary}".lower()
    if any(k in text for k in ["世界观", "ip", "角色", "设定", "剧情", "卡牌", "slg", "游戏"]):
        return "game_ip_worldbuilding"
    if any(k in text for k in ["研究", "实验", "问卷", "论文", "数据", "分析", "报告"]):
        return "research_analysis"
    if any(k in text for k in ["工具", "脚本", "控制台", "软件", "界面", "python", "代码", "系统"]):
        return "software_tooling"
    return "default"

def fill_template(template: str, mapping: dict[str, str]) -> str:
    for key, value in mapping.items():
        template = template.replace("{{" + key + "}}", value)
    return template

def call_deepseek(messages: list[dict[str, str]], model: str) -> str | None:
    api_key = os.getenv("DEEPSEEK_API_KEY", "").strip()
    if not api_key:
        return None
    base_url = os.getenv("DEEPSEEK_BASE_URL", "https://api.deepseek.com/v1").rstrip("/")
    url = base_url + "/chat/completions"
    payload = {
        "model": model,
        "messages": messages,
        "temperature": 0.3,
        "response_format": {"type": "json_object"},
    }
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}",
        },
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=120) as response:
        body = json.loads(response.read().decode("utf-8"))
        return body["choices"][0]["message"]["content"]

def resolve_external_project_dir(project_name: str, external_project_dir_arg: str) -> Path:
    if external_project_dir_arg.strip():
        return Path(external_project_dir_arg).expanduser()

    desktop = Path.home() / "Desktop"
    candidates = [
        desktop / "项目" / project_name,
        desktop / "projects" / project_name,
        desktop / "workspace_projects" / project_name,
    ]

    for candidate in candidates:
        parent = candidate.parent
        if parent.exists():
            return candidate

    default_parent = desktop / "项目"
    default_parent.mkdir(parents=True, exist_ok=True)
    return default_parent / project_name

def fallback_intake_analysis(project_name: str, profile: str, inventory: list[str]) -> dict[str, Any]:
    return {
        "project_name": project_name,
        "recommended_profile": profile,
        "project_type": profile,
        "core_goal": f"围绕 {project_name} 形成一个可执行的项目推进方案。",
        "problem_statement": "当前输入已经提供了想法或材料，但还缺少明确的工作流程、任务拆解与决策关口设计。",
        "key_constraints": [
            "优先使用当前 AI 系统 V1 已有的脚本、知识层和交付物层",
            "仅把真正高价值和高风险节点留给人工决策",
            "能自动化的部分尽量批量自动化"
        ],
        "known_inputs": inventory[:20],
        "major_risks": [
            "输入信息可能不足",
            "项目范围可能过大",
            "任务自动化边界尚未完全明确"
        ],
        "automation_candidates": [
            "初步摘要与结构化整理",
            "方向候选整理",
            "工作流蓝图生成",
            "任务清单生成"
        ],
        "required_human_decisions": [
            "是否立项",
            "蓝图是否确认",
            "关键路线如何选择",
            "最终结果是否签发"
        ],
        "suggested_outputs": ["brief", "plan", "report", "task_manifest"],
        "current_stage": "intake",
        "priority_level": "medium",
        "recommended_next_step": "确认 intake brief 和 workflow blueprint，再进入第一轮任务执行。"
    }

def fallback_workflow_blueprint(project_name: str) -> dict[str, Any]:
    return {
        "project_name": project_name,
        "workflow_summary": "先完成项目导入后的方向判断与蓝图确认，再进入第一轮具体任务推进。",
        "phases": [
            {
                "phase_id": "phase_1",
                "phase_name": "导入确认",
                "goal": "确认项目目标、边界和第一轮推进方向。",
                "tasks": [
                    {
                        "task_id": "task_1_1",
                        "task_name": "确认 intake brief",
                        "task_type": "brief_confirmation",
                        "description": "基于 intake brief 明确项目目标与边界，决定是否继续。",
                        "owner": "user",
                        "model_route": "gpt_manual",
                        "need_ai_review": False,
                        "need_human_gate": "gate_0",
                        "expected_output": "deliverables/projects/<ProjectName>/brief/intake_brief.md"
                    }
                ]
            },
            {
                "phase_id": "phase_2",
                "phase_name": "方向草案生成",
                "goal": "围绕项目核心问题生成第一轮可比较的方案草案。",
                "tasks": [
                    {
                        "task_id": "task_2_1",
                        "task_name": "生成世界观方向候选",
                        "task_type": "option_generation",
                        "description": "输出 2 到 3 个可比较的世界观方向草案，供后续选择。",
                        "owner": "system",
                        "model_route": "deepseek_reasoner",
                        "need_ai_review": True,
                        "need_human_gate": "",
                        "expected_output": "deliverables/projects/<ProjectName>/plan/worldview_direction_options.md"
                    },
                    {
                        "task_id": "task_2_2",
                        "task_name": "生成产品路线候选",
                        "task_type": "option_generation",
                        "description": "围绕载体与优先级给出 2 到 3 个产品路线候选。",
                        "owner": "system",
                        "model_route": "deepseek_reasoner",
                        "need_ai_review": True,
                        "need_human_gate": "",
                        "expected_output": "deliverables/projects/<ProjectName>/plan/product_route_options.md"
                    },
                    {
                        "task_id": "task_2_3",
                        "task_name": "输出验证优先级建议",
                        "task_type": "analysis",
                        "description": "说明先验证什么、为什么先验证、验证风险是什么。",
                        "owner": "system",
                        "model_route": "deepseek_default",
                        "need_ai_review": False,
                        "need_human_gate": "",
                        "expected_output": "deliverables/projects/<ProjectName>/report/validation_priority_report.md"
                    }
                ]
            },
            {
                "phase_id": "phase_3",
                "phase_name": "蓝图确认与清单冻结",
                "goal": "把第一轮工作蓝图和任务清单固定下来，等待人工确认。",
                "tasks": [
                    {
                        "task_id": "task_3_1",
                        "task_name": "确认 workflow blueprint",
                        "task_type": "blueprint_confirmation",
                        "description": "审阅工作流蓝图与阶段划分，决定是否进入下一轮执行。",
                        "owner": "user",
                        "model_route": "gpt_manual",
                        "need_ai_review": False,
                        "need_human_gate": "gate_1",
                        "expected_output": "deliverables/projects/<ProjectName>/plan/workflow_blueprint.md"
                    },
                    {
                        "task_id": "task_3_2",
                        "task_name": "冻结第一轮 task manifest",
                        "task_type": "task_manifest",
                        "description": "输出下一轮可真正执行的任务清单。",
                        "owner": "system",
                        "model_route": "deepseek_default",
                        "need_ai_review": False,
                        "need_human_gate": "gate_1",
                        "expected_output": "projects/<ProjectName>/task_manifest.yaml"
                    }
                ]
            }
        ],
        "first_action": "先阅读 intake_brief.md，并判断这个项目是否立项。",
        "brief_outline": ["项目目标", "输入概况", "核心问题", "风险与约束", "建议下一步"],
        "plan_outline": ["阶段划分", "方向候选", "验证建议", "人工决策关口", "第一轮任务清单"]
    }

def ensure_json_dict(raw: str, fallback: dict[str, Any]) -> dict[str, Any]:
    try:
        data = json.loads(raw)
        if isinstance(data, dict):
            return data
    except Exception:
        pass
    return fallback

def normalize_output_path(project_name: str, path_text: str, task_type: str, owner: str, gate: str) -> str:
    text = (path_text or "").strip()
    text = text.replace(project_name, "<ProjectName>")
    lower = text.lower()

    if lower.endswith((".pdf", ".docx", ".xlsx", ".zip")):
        text = ""

    if owner == "user" and gate == "gate_0":
        return "deliverables/projects/<ProjectName>/brief/intake_brief.md"
    if owner == "user" and gate == "gate_1":
        return "deliverables/projects/<ProjectName>/plan/workflow_blueprint.md"
    if task_type == "task_manifest":
        return "projects/<ProjectName>/task_manifest.yaml"

    if text.startswith("deliverables/projects/<ProjectName>/") or text == "projects/<ProjectName>/task_manifest.yaml":
        return text

    mapping = {
        "analysis": "deliverables/projects/<ProjectName>/report/analysis_draft.md",
        "option_generation": "deliverables/projects/<ProjectName>/plan/options_draft.md",
        "brief_confirmation": "deliverables/projects/<ProjectName>/brief/intake_brief.md",
        "blueprint_confirmation": "deliverables/projects/<ProjectName>/plan/workflow_blueprint.md",
        "task_manifest": "projects/<ProjectName>/task_manifest.yaml",
        "planning": "deliverables/projects/<ProjectName>/plan/planning_draft.md",
        "drafting": "deliverables/projects/<ProjectName>/plan/drafting_draft.md",
        "confirmation": "deliverables/projects/<ProjectName>/plan/workflow_blueprint.md",
    }
    return mapping.get(task_type, f"deliverables/projects/<ProjectName>/plan/{task_type}_draft.md")

def replace_common_english(text: str) -> str:
    if not isinstance(text, str):
        return text
    replacements = {
        "Analyze Raw Idea and Generate World Setting Draft": "分析原始想法并生成世界观草案",
        "Draft Product Roadmap and Content Matrix Candidates": "生成产品路线与内容矩阵候选",
        "Suggest Validation Directions Based on Trends": "提出验证方向建议",
        "Outline AI Automation Tasks": "梳理 AI 自动化任务",
        "Wait for Human Confirmation on Workflow Blueprint": "等待人工确认工作蓝图",
        "First-round blueprint focusing on direction clarification": "第一轮蓝图聚焦方向澄清",
        "Execute task_1": "先阅读 intake_brief 并决定是否立项，然后再进入第一轮方向草案生成",
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    return text

def normalize_task(project_name: str, phase_id: str, idx: int, task: dict[str, Any]) -> dict[str, Any]:
    owner = task.get("owner", "system")
    if owner not in ALLOWED_OWNERS:
        owner = "system"

    model_route = task.get("model_route", "deepseek_default")
    if model_route not in ALLOWED_MODEL_ROUTES:
        if owner == "user":
            model_route = "gpt_manual"
        elif owner == "cursor":
            model_route = "cursor_code"
        else:
            model_route = "deepseek_default"

    gate = task.get("need_human_gate", "")
    if gate not in ALLOWED_GATES:
        gate = ""

    task_type = task.get("task_type", "analysis") or "analysis"
    task_name = replace_common_english(task.get("task_name") or f"任务_{idx}")
    description = replace_common_english(task.get("description") or "待补充说明。")
    expected_output = normalize_output_path(project_name, task.get("expected_output", ""), task_type, owner, gate)

    return {
        "task_id": task.get("task_id") or f"{phase_id}_task_{idx}",
        "task_name": task_name,
        "task_type": task_type,
        "description": description,
        "owner": owner,
        "model_route": model_route,
        "need_ai_review": bool(task.get("need_ai_review", False)),
        "need_human_gate": gate,
        "expected_output": expected_output,
    }

def sanitize_blueprint(project_name: str, data: dict[str, Any]) -> dict[str, Any]:
    phases = data.get("phases", [])
    if not isinstance(phases, list) or not phases:
        return fallback_workflow_blueprint(project_name)

    new_phases = []
    total_tasks = 0
    for p_idx, phase in enumerate(phases[:4], start=1):
        phase_id = phase.get("phase_id") or f"phase_{p_idx}"
        phase_name = replace_common_english(phase.get("phase_name") or f"阶段 {p_idx}")
        goal = replace_common_english(phase.get("goal") or "待补充目标。")

        tasks = phase.get("tasks", [])
        if not isinstance(tasks, list):
            tasks = []

        new_tasks = []
        for t_idx, task in enumerate(tasks, start=1):
            if total_tasks >= 8:
                break
            normalized = normalize_task(project_name, phase_id, t_idx, task)
            out = normalized["expected_output"].lower()
            if "final_deliverable" in out or "signed" in out:
                continue
            new_tasks.append(normalized)
            total_tasks += 1

        if new_tasks:
            new_phases.append({
                "phase_id": phase_id,
                "phase_name": phase_name,
                "goal": goal,
                "tasks": new_tasks,
            })

    if not new_phases:
        return fallback_workflow_blueprint(project_name)

    data["project_name"] = project_name
    data["phases"] = new_phases
    data["workflow_summary"] = replace_common_english(data.get("workflow_summary") or "先完成导入确认与第一轮方向收敛，再进入下一轮任务执行。")
    data["first_action"] = "先阅读 intake_brief.md，并判断这个项目是否立项。"
    data["brief_outline"] = data.get("brief_outline") or ["项目目标", "输入概况", "核心问题", "风险与约束", "建议下一步"]
    data["plan_outline"] = data.get("plan_outline") or ["阶段划分", "方向候选", "验证建议", "人工决策关口", "第一轮任务清单"]
    return data

def render_brief_md(data: dict[str, Any]) -> str:
    lines = [
        f"# {data.get('project_name', '')} - Intake Brief", "",
        "## 1. 项目目标", data.get("core_goal", ""), "",
        "## 2. 问题定义", data.get("problem_statement", ""), "",
        "## 3. 当前阶段", data.get("current_stage", ""), "",
        "## 4. 已知输入",
    ]
    for item in data.get("known_inputs", []):
        lines.append(f"- {item}")
    lines.extend(["", "## 5. 关键约束"])
    for item in data.get("key_constraints", []):
        lines.append(f"- {item}")
    lines.extend(["", "## 6. 可自动化部分"])
    for item in data.get("automation_candidates", []):
        lines.append(f"- {item}")
    lines.extend(["", "## 7. 必须人工决策的节点"])
    for item in data.get("required_human_decisions", []):
        lines.append(f"- {item}")
    lines.extend(["", "## 8. 主要风险"])
    for item in data.get("major_risks", []):
        lines.append(f"- {item}")
    lines.extend(["", "## 9. 建议下一步", data.get("recommended_next_step", ""), ""])
    return "\n".join(lines)

def render_blueprint_md(data: dict[str, Any]) -> str:
    lines = [
        f"# {data.get('project_name', '')} - Workflow Blueprint", "",
        "## 1. 蓝图概述", data.get("workflow_summary", ""), "",
        "## 2. 第一动作", data.get("first_action", ""), "",
        "## 3. 阶段与任务", ""
    ]
    for phase in data.get("phases", []):
        lines.append(f"### {phase.get('phase_name', '')} ({phase.get('phase_id', '')})")
        lines.append(phase.get("goal", ""))
        lines.append("")
        for task in phase.get("tasks", []):
            lines.append(f"- **{task.get('task_name', '')}**")
            lines.append(f"  - task_id: {task.get('task_id', '')}")
            lines.append(f"  - task_type: {task.get('task_type', '')}")
            lines.append(f"  - owner: {task.get('owner', '')}")
            lines.append(f"  - model_route: {task.get('model_route', '')}")
            lines.append(f"  - need_ai_review: {task.get('need_ai_review', False)}")
            lines.append(f"  - need_human_gate: {task.get('need_human_gate', '')}")
            lines.append(f"  - expected_output: {task.get('expected_output', '')}")
            lines.append(f"  - description: {task.get('description', '')}")
        lines.append("")
    return "\n".join(lines)

def render_task_manifest_yaml(data: dict[str, Any]) -> str:
    lines = ["version: 1", f'project_name: "{data.get("project_name", "")}"', "tasks:"]
    for phase in data.get("phases", []):
        for task in phase.get("tasks", []):
            desc = str(task.get("description", "")).replace('"', "'")
            lines.extend([
                f'  - task_id: "{task.get("task_id", "")}"',
                f'    phase_id: "{phase.get("phase_id", "")}"',
                f'    task_name: "{task.get("task_name", "")}"',
                f'    task_type: "{task.get("task_type", "")}"',
                f'    owner: "{task.get("owner", "")}"',
                f'    model_route: "{task.get("model_route", "")}"',
                f'    need_ai_review: {"true" if task.get("need_ai_review", False) else "false"}',
                f'    need_human_gate: "{task.get("need_human_gate", "")}"',
                f'    expected_output: "{task.get("expected_output", "")}"',
                f'    status: "pending"',
                f'    description: "{desc}"',
            ])
    return "\n".join(lines) + "\n"

def main() -> int:
    args = parse_args()

    system_root = Path(args.system_root)
    input_path = Path(args.input_path)
    external_project_dir = resolve_external_project_dir(args.project_name, args.external_project_dir)

    outputs_dir = system_root / "outputs" / "intake" / args.project_name
    brief_path = system_root / "deliverables" / "projects" / args.project_name / "brief" / "intake_brief.md"
    plan_path = system_root / "deliverables" / "projects" / args.project_name / "plan" / "workflow_blueprint.md"
    task_manifest_path = external_project_dir / "task_manifest.yaml"
    analysis_json_path = outputs_dir / "intake_analysis.json"
    blueprint_json_path = outputs_dir / "workflow_blueprint.json"

    outputs_dir.mkdir(parents=True, exist_ok=True)
    brief_path.parent.mkdir(parents=True, exist_ok=True)
    plan_path.parent.mkdir(parents=True, exist_ok=True)
    external_project_dir.mkdir(parents=True, exist_ok=True)

    summary, inventory = collect_input_summary(args.input_mode, input_path)
    profile = auto_profile(args.project_name, summary, args.profile)

    prompt_root = system_root / "prompts" / "intake"
    intake_prompt = read_prompt(prompt_root / "project_intake_analysis.md")
    blueprint_prompt = read_prompt(prompt_root / "workflow_blueprint_generation.md")
    approval_gates_text = load_text(system_root / "config" / "approval_gates.yaml")
    model_routes_text = load_text(system_root / "config" / "model_routes.yaml")

    filled_intake_prompt = fill_template(intake_prompt, {
        "project_name": args.project_name,
        "profile_name": profile,
        "input_mode": args.input_mode,
        "input_summary": summary[:12000],
        "file_inventory": "\n".join(inventory[:200]),
        "user_note": "无额外补充说明",
    })

    intake_raw = call_deepseek(
        messages=[
            {"role": "system", "content": "你是严谨的项目导入分析器，请全部使用中文。"},
            {"role": "user", "content": filled_intake_prompt},
        ],
        model="deepseek-reasoner",
    )

    intake_data = ensure_json_dict(intake_raw or "", fallback_intake_analysis(args.project_name, profile, inventory))
    intake_data["project_name"] = args.project_name
    intake_data["recommended_profile"] = intake_data.get("recommended_profile") or profile

    filled_blueprint_prompt = fill_template(blueprint_prompt, {
        "project_name": args.project_name,
        "intake_analysis_json": json.dumps(intake_data, ensure_ascii=False, indent=2),
        "approval_gates": approval_gates_text,
        "model_routes": model_routes_text,
    })

    blueprint_raw = call_deepseek(
        messages=[
            {"role": "system", "content": "你是严谨的 workflow blueprint 生成器，请全部使用中文，并聚焦第一轮蓝图。"},
            {"role": "user", "content": filled_blueprint_prompt},
        ],
        model="deepseek-reasoner",
    )

    blueprint_data = ensure_json_dict(blueprint_raw or "", fallback_workflow_blueprint(args.project_name))
    blueprint_data = sanitize_blueprint(args.project_name, blueprint_data)

    analysis_json_path.write_text(json.dumps(intake_data, ensure_ascii=False, indent=2), encoding="utf-8")
    blueprint_json_path.write_text(json.dumps(blueprint_data, ensure_ascii=False, indent=2), encoding="utf-8")
    brief_path.write_text(render_brief_md(intake_data), encoding="utf-8")
    plan_path.write_text(render_blueprint_md(blueprint_data), encoding="utf-8")
    task_manifest_path.write_text(render_task_manifest_yaml(blueprint_data), encoding="utf-8")

    print("== Intake Analysis Completed ==")
    print(f"Project name         : {args.project_name}")
    print(f"Profile              : {profile}")
    print(f"Resolved project dir : {external_project_dir}")
    print(f"Brief                : {brief_path}")
    print(f"Blueprint            : {plan_path}")
    print(f"Task manifest        : {task_manifest_path}")
    print(f"Analysis JSON        : {analysis_json_path}")
    print(f"Workflow JSON        : {blueprint_json_path}")
    if not os.getenv("DEEPSEEK_API_KEY", "").strip():
        print("Warning: DEEPSEEK_API_KEY 未设置，本次使用了本地 fallback 结果。")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
