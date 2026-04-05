# AI Agent System Root Repo

这不是单一项目仓库，而是你的 **AI 工作系统母仓库**。

当前定位：
- `AI_agent_bootstrap_pack_stage3/` 是系统根目录
- `projects/` 存放试运行或长期子项目
- `PsyLens` 只是其中一个子项目，不再作为系统唯一主线

## 当前阶段目标
1. 固定系统根目录结构
2. 固定知识层 / 规则层 / 执行层接口
3. 建立子项目接入规范
4. 建立 scout 与 health check
5. 再考虑复杂常驻 agent 或远程控制

## 目录原则
- 系统级规则、注册表、路由配置放在根目录
- 子项目只保留项目本地规则与实现，不复制整个系统逻辑
- 所有新项目都先登记，再建目录，再挂接规则

详细说明请看：
- `docs/system/root_repo_layout.md`
- `docs/system/subproject_onboarding.md`
- `docs/system/stage3_implementation_sequence.md`
