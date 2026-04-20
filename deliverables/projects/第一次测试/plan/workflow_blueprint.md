# 第一次测试 - Workflow Blueprint

## 1. 蓝图概述
本项目'第一次测试'的第一轮工作蓝图专注于项目启动阶段。通过系统分析intake简报确认立项，然后细化测试需求、制定候选策略、框架草案和环境建议，最后生成工作蓝图并等待人工确认，确保测试验证项目正确初始化。

## 2. 第一动作
先阅读 intake_brief.md，并判断这个项目是否立项。

## 3. 阶段与任务

### 项目立项确认 (phase_1)
基于intake分析确认项目是否继续，并生成立项简报。

- **评估项目导入简报并确认立项**
  - task_id: task_1
  - task_type: 分析
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_0
  - expected_output: deliverables/projects/<ProjectName>/brief/intake_brief.md
  - description: 基于提供的intake分析JSON，审查项目细节，判断是否应继续项目，为第一轮工作提供决策基础。

### 测试方向与方案制定 (phase_2)
细化测试需求，制定测试策略和用例框架，准备环境建议。

- **细化测试需求并形成候选测试策略**
  - task_id: task_2
  - task_type: 规划
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_2
  - expected_output: deliverables/projects/<ProjectName>/plan/test_strategy_options.md
  - description: 根据项目核心目标和问题陈述，明确测试的具体范围和优先级，制定多个测试策略选项，供人工选择最佳方向。
- **制定测试用例初步框架**
  - task_id: task_3
  - task_type: 结构化
  - owner: system
  - model_route: deepseek_default
  - need_ai_review: True
  - need_human_gate: gate_3
  - expected_output: deliverables/projects/<ProjectName>/spec/test_case_framework.md
  - description: 基于细化的测试需求，设计测试用例的基本结构和内容草案，为后续详细制定提供框架。
- **准备测试环境配置建议**
  - task_id: task_4
  - task_type: 分析
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: 
  - expected_output: deliverables/projects/<ProjectName>/plan/test_env_recommendation.md
  - description: 分析已知输入和主要风险，提出测试环境的配置建议，以确保测试环境与实际使用场景一致，提高测试有效性。

### 工作蓝图生成与确认 (phase_3)
生成第一轮工作蓝图，并提交给用户确认。

- **生成第一轮工作流程蓝图**
  - task_id: task_5
  - task_type: 工作流蓝图
  - owner: system
  - model_route: deepseek_reasoner
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: projects/<ProjectName>/task_manifest.yaml
  - description: 整合以上所有分析结果，生成详细的工作流程蓝图，包括阶段划分和任务清单，作为项目执行的指南。
- **提交蓝图并等待人工确认**
  - task_id: task_6
  - task_type: 确认
  - owner: user
  - model_route: gpt_manual
  - need_ai_review: False
  - need_human_gate: gate_1
  - expected_output: deliverables/projects/<ProjectName>/plan/workflow_blueprint.md
  - description: 将生成的蓝图提交给用户进行审查和确认，确保工作流符合项目需求，如有需要则进行修订。
