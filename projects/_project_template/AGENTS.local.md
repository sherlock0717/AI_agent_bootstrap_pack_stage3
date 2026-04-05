# __PROJECT_NAME__ Local Rules

## 项目定位
__PROJECT_NAME__ 是接入 AI 系统的外部项目，用于 __PROJECT_PURPOSE__。

## 项目边界
- 该项目不是系统母仓库本体。
- 该项目真实代码仓库位于外部路径。
- 系统母目录中的 `projects/__PROJECT_NAME__/` 只负责保存项目登记信息、局部规则和接入说明。

## 当前阶段目标
当前阶段优先关注：
- 项目接入是否清晰
- 局部规则是否明确
- 输出、日志、知识记录是否能进入统一结构
- 是否适合纳入长期管理

## 工具优先级
- 代码与脚本修改：优先使用 Cursor
- 复杂调试与规则梳理：可使用 Claude Code
- 系统设计、流程整理、文档规划：可使用 ChatGPT
- 可确定执行的步骤：优先写成脚本，不只停留在对话中

## 输出与归档
- 项目知识记录放在：`knowledge/projects/__PROJECT_NAME__/`
- 项目输出放在：`outputs/projects/__PROJECT_NAME__/`
- 项目日志放在：`logs/projects/__PROJECT_NAME__/`

## 当前限制
__CURRENT_LIMITATIONS__