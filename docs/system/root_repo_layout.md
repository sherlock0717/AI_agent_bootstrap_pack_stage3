# 系统母仓库目录落地方案

## 一、目标

当前根目录应从“模板包”升级为“系统母仓库”。

你的实际本地关系已经明确：
- 系统根：`C:\Users\22358\Desktop\系统\AI_agent_bootstrap_pack`
- 子项目示例：`C:\Users\22358\Desktop\项目\PsyLens_GitHub_Repo\PsyLens`

因此，系统母仓库不再直接承载某一个项目，而要承载：
- 规则
- 模板
- 注册表
- 路由
- scout
- 健康检查
- 子项目接入契约

## 二、建议目录

```text
AI_agent_bootstrap_pack/
├─ AGENTS.md
├─ CLAUDE.md
├─ README.md
├─ .cursor/
├─ .github/
├─ config/
│  ├─ model_routing.yaml
│  ├─ project_registry.yaml
│  ├─ system_routes.yaml
│  ├─ task_router.yaml
│  └─ tech_watch_sources.yaml
├─ docs/
│  ├─ workflow.md
│  ├─ tool_stack_decision.md
│  └─ system/
│     ├─ root_repo_layout.md
│     ├─ subproject_onboarding.md
│     ├─ stage3_implementation_sequence.md
│     ├─ execution_contract.md
│     └─ knowledge_layer_governance.md
├─ knowledge/
│  ├─ inbox/
│  ├─ sessions/
│  ├─ decisions/
│  └─ PRD/
├─ logs/
├─ outputs/
├─ obsidian_templates/
├─ prompts/
├─ projects/
│  ├─ PsyLens/
│  └─ _project_template/
├─ scout/
│  ├─ raw/
│  ├─ snapshots/
│  └─ summaries/
├─ scripts/
│  ├─ check_system_health.py
│  ├─ register_project.py
│  └─ run_tech_scout.py
└─ templates/
   └─ subproject/
      ├─ README.template.md
      ├─ AGENTS.local.template.md
      └─ project_manifest.template.yaml
```

## 三、根目录与子项目边界

### 根目录负责
- 系统级规则
- 工具路由
- 模型路由
- 技术雷达
- 子项目注册
- 子项目模板
- 知识层治理

### 子项目负责
- 项目本地 README
- 项目本地数据 / 脚本 / 交付物
- 项目本地 prompt
- 项目特定 AGENTS.local.md

## 四、当前不建议的结构

不建议继续让系统规则直接写成“当前主线是 PsyLens”。

更好的写法应是：
- 系统当前已有一个试运行子项目：PsyLens
- 后续还可继续接入用户研究、HR、写作、内容创作等项目

## 五、最小迁移原则

1. 先升级系统根目录，不迁移子项目内容
2. 再建立 `project_registry.yaml`
3. 再把 PsyLens 作为第一个登记项目
4. 只有在系统规则稳定后，才让子项目回连系统根
