# Agent Entrypoints

## 目的
这份文档说明系统如何向不同代理暴露分层信息。

## 当前结构

### AGENTS.md
面向通用代理的顶层规则入口。
作用：
- 提供系统总体定位
- 说明边界与禁区
- 提供对不同代理都通用的规则

### CLAUDE.md
面向 Claude Code 的精简入口。
作用：
- 给 Claude 一个简洁且高优先级的项目级入口
- 避免把所有长规则直接塞进 CLAUDE.md
- 通过导入与 .claude/rules/ 做分层

### .claude/rules/
面向 Claude 的规则模块与路径级规则。
作用：
- 把不同目录的工作规范分开
- 降低主入口长度
- 让 Claude 在相关文件上下文中读取对应规则

### .github/copilot-instructions.md
面向 GitHub Copilot 的仓库级说明。
作用：
- 给 Copilot 提供整体仓库背景
- 定义全局行为偏好

### .github/instructions/*.instructions.md
面向 Copilot 的路径级说明。
作用：
- 对 scripts / knowledge / docs / projects 等目录分开约束
- 与仓库级 copilot-instructions 叠加使用

## 当前原则
- 总入口尽量短
- 路径级规则承接细节
- 可共享的内容不要无意义重复
- 项目本体规则、知识规则、执行规则要分开
