# V1ChainSmoke2 - Workflow Blueprint

## 1. 蓝图概述
第一轮工作蓝图聚焦于立项确认和测试计划制定，包括阅读需求、形成草案、验证和人工确认，确保项目方向明确并准备下一步。

## 2. 第一动作
先阅读 intake_brief.md，并判断这个项目是否立项。

## 3. 阶段与任务

### 立项确认 (phase_1)
确认项目是否正式立项，基于intake analysis进行判断。

- **立项判断**
  - task_id: task_1
  - task_type: 确认
  - owner: user
  - model_route: gpt_manual
  - need_ai_review: False
  - need_human_gate: gate_0
  - expected_output: deliverables/projects/<ProjectName>/brief/intake_brief.md
  - description: 这是第一轮蓝图的第一步，需要先阅读intake_brief并判断是否立项，遵循gate_0的要求。

### 测试计划制定 (phase_2)
制定详细测试计划并收集测试需求，形成草案进行验证。

- **阅读项目需求**
  - task_id: task_2
  - task_type: 分析
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/brief/requirements_summary.md
  - description: 基于intake analysis和raw_idea_text.txt，理解项目核心目标、问题陈述和约束，为制定测试计划做准备。
- **形成测试计划草案**
  - task_id: task_3
  - task_type: 规划
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: True
  - need_human_gate: gate_1
  - expected_output: deliverables/projects/<ProjectName>/plan/test_plan_draft.md
  - description: 根据需求分析，制定初步测试计划，包括测试范围、策略和资源分配。
- **验证草案可行性**
  - task_id: task_4
  - task_type: 验证
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_2
  - expected_output: deliverables/projects/<ProjectName>/plan/validation_report.md
  - description: 评估测试计划草案的可行性，考虑时间限制、资源约束和风险。
- **等待人工确认**
  - task_id: task_5
  - task_type: 等待
  - owner: user
  - model_route: gpt_manual
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: deliverables/projects/<ProjectName>/plan/workflow_blueprint.md
  - description: 在形成草案和验证后，等待用户确认测试计划和路线。
