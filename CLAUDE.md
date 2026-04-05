@AGENTS.md

# Claude Entry

## 系统定位
这是一个长期可复用的 AI 工作系统母仓库，不是单一项目代码仓库。

## 你现在应优先理解的内容
- 系统规则总入口：AGENTS.md
- 资产边界：@docs/system/asset_boundary.md
- 路径规则说明：@docs/system/path_rules.md
- 配置校验层说明：@docs/system/config_validation.md
- agent 分层入口：@docs/system/agent_entrypoints.md

## 当前工作原则
- 可脚本化的步骤优先脚本化
- 外部项目通过 projects/ 中的接入点管理
- outputs 是运行输出，knowledge 是长期沉淀
- 修改系统结构时，应同步更新 docs / config / knowledge 中相关内容
- 如果某项改动会长期影响系统，应考虑补 system note 或 decision note

## 目录意识
- scripts/：执行逻辑
- knowledge/：长期记忆
- docs/：稳定说明
- projects/：外部项目接入点

## Claude 工作方式
- 优先读取与你当前操作目录相关的规则
- 如果规则已经在 .claude/rules/ 中细分，不要把所有细节重复塞进这里
- 如果你发现入口文件过长，应继续拆分，而不是继续堆在 CLAUDE.md
