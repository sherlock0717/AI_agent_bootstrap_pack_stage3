# IP_Design_Demo - Workflow Blueprint

## 1. 蓝图概述
第一轮工作流专注于项目立项确认、世界观核心设定草案生成、产品路线候选制定以及验证方向建议，等待人工关键决策以推进后续步骤。

## 2. 第一动作
先阅读 intake_brief.md，并判断这个项目是否立项。

## 3. 阶段与任务

### 立项确认阶段 (phase_1)
完成项目导入分析并等待用户立项确认

- **处理 intake analysis 并生成 brief**
  - task_id: task_1
  - task_type: ai_analysis_task
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_0
  - expected_output: deliverables/projects/<ProjectName>/brief/intake_brief.md
  - description: AI 系统读取 intake analysis JSON，生成简要报告，为立项决策做准备。

### 草案生成阶段 (phase_2)
生成世界观核心设定和产品路线候选方案

- **生成世界观核心设定草案**
  - task_id: task_2
  - task_type: ai_generation_task
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_2
  - expected_output: deliverables/projects/<ProjectName>/spec/world_setting_draft.md
  - description: 基于 brief，AI 生成世界观的核心设定草案，包括关键元素和扩展性考虑，供人工确认。
- **制定产品衍生路线候选方案**
  - task_id: task_3
  - task_type: ai_planning_task
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_2
  - expected_output: deliverables/projects/<ProjectName>/plan/product_roadmap_candidates.md
  - description: AI 分析多媒介扩展性，提出产品路线候选，如小说、视频等的优先级和路径。

### 确认与规划阶段 (phase_3)
提出初步验证方向并等待工作流蓝图确认

- **提出优先验证方向建议**
  - task_id: task_4
  - task_type: ai_analysis_task
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/report/validation_suggestions.md
  - description: AI 基于风险和市场分析，提出验证方向的建议，以降低开发风险。
- **生成工作流蓝图并触发确认**
  - task_id: task_5
  - task_type: ai_integration_task
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: projects/<ProjectName>/task_manifest.yaml
  - description: 整合所有草案和建议，生成第一轮工作流蓝图文档，并等待用户确认。
