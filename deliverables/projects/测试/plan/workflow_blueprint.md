# 测试 - Workflow Blueprint

## 1. 蓝图概述
本项目为测试AI工作系统的导入分析功能，第一轮蓝图包括项目启动确认、蓝图生成、方向分析和初步验证执行，共三个阶段六个任务，优先人工确认以确保方向正确。

## 2. 第一动作
先阅读 intake_brief.md，并判断这个项目是否立项。

## 3. 阶段与任务

### 项目启动确认 (phase_1)
确认项目是否立项，为后续工作奠定基础

- **读取项目导入概要并触发立项确认**
  - task_id: task_1
  - task_type: confirmation
  - owner: system
  - model_route: deepseek_default
  - need_ai_review: False
  - need_human_gate: gate_0
  - expected_output: deliverables/projects/<ProjectName>/brief/confirmation_result.md
  - description: 系统读取intake_brief内容，触发gate_0等待用户确认是否继续项目。

### 蓝图与方案生成 (phase_2)
生成工作蓝图、候选方向和验证计划

- **生成第一轮工作蓝图**
  - task_id: task_2
  - task_type: generation
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/workflow_blueprint.md
  - description: 基于intake分析，使用deepseek_reasoner生成第一轮工作蓝图。
- **分析项目目标形成候选方向**
  - task_id: task_3
  - task_type: analysis
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/spec/direction_candidates.md
  - description: 分析core_goal和key_constraints，形成可能的测试方向候选。
- **制定验证建议和测试计划**
  - task_id: task_4
  - task_type: planning
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/verification_plan.md
  - description: 基于major_risks和automation_candidates，制定初步验证建议。

### 确认与执行 (phase_3)
确认蓝图并执行初步测试任务

- **编译任务清单并触发蓝图确认**
  - task_id: task_5
  - task_type: compilation
  - owner: system
  - model_route: deepseek_default
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: projects/<ProjectName>/task_manifest.yaml
  - description: 整合蓝图和方案，生成任务清单，并触发gate_1等待用户确认。
- **执行初步测试以验证系统功能**
  - task_id: task_6
  - task_type: execution
  - owner: system
  - model_route: deepseek_default
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/report/preliminary_test_report.md
  - description: 在用户确认蓝图后，执行测试任务验证AI工作系统的导入分析功能。
