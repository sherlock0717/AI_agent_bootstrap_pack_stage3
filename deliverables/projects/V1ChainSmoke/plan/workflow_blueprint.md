# V1ChainSmoke - Workflow Blueprint

## 1. 蓝图概述
基于V1ChainSmoke项目的intake analysis，第一轮工作蓝图聚焦于项目立项确认、测试计划草案生成和蓝图确认，旨在明确方向并形成候选方案，为后续执行奠定基础。

## 2. 第一动作
先阅读 intake_brief.md，并判断这个项目是否立项。

## 3. 阶段与任务

### 项目立项确认 (phase_1)
确认项目是否继续，基于导入分析结果评估可行性。

- **阅读intake_brief并评估立项条件**
  - task_id: task_1
  - task_type: analysis
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_0
  - expected_output: projects/<ProjectName>/task_manifest.yaml
  - description: 这是第一轮任务，需要先确认项目是否立项，以避免无效工作。系统自动分析intake analysis内容，判断项目是否符合核心目标和约束条件。

### 测试计划草案生成 (phase_2)
生成初步测试计划草案，明确测试范围和方向，形成候选方案。

- **分析测试需求并形成候选方案**
  - task_id: task_2
  - task_type: planning
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/test_scope_candidates.md
  - description: 这是第一轮近端任务，旨在明确测试方向。基于core_goal和problem_statement，分析测试需求，生成多个测试范围候选以供选择。
- **生成测试框架草案**
  - task_id: task_3
  - task_type: design
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/test_framework_draft.md
  - description: 这是第一轮任务，需要为后续执行提供框架。设计测试框架草案，包括任务定义、执行步骤和预期结果，基于known_inputs和automation_candidates。
- **提供验证建议**
  - task_id: task_4
  - task_type: recommendation
  - owner: system
  - model_route: deepseek_default
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/validation_suggestions.md
  - description: 这是第一轮任务，旨在提前识别风险并给出验证建议。基于major_risks和key_constraints，提供初步验证策略和建议。

### 蓝图确认 (phase_3)
确认生成的工作蓝图和任务清单，确保方向正确并等待人工审批。

- **提交workflow_blueprint供用户确认**
  - task_id: task_5
  - task_type: confirmation
  - owner: user
  - model_route: gpt_manual
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: deliverables/projects/<ProjectName>/plan/workflow_blueprint.md
  - description: 这是第一轮关键任务，需要用户确认蓝图以避免偏差。将生成的workflow blueprint和更新后的task_manifest提交给用户进行审批。
