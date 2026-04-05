# Path Rules

## 目的
随着系统逐渐复杂，单一全局规则已经不够。
不同目录承担不同职责，因此需要分路径规则。

## 当前原则
- scripts/：面向执行与自动化
- knowledge/：面向长期沉淀与系统记忆
- docs/：面向稳定说明与人类阅读
- projects/：面向外部项目接入与登记

## 为什么这样做
这样可以避免：
- 所有内容都套用同一套模糊规则
- 文档写得像脚本日志
- 知识笔记写得像说明书
- 项目接入信息和真实代码边界混乱

## 当前实现方式
1. docs/system/path_rules.md：总说明
2. config/path_rules.yaml：路径与规则映射
3. .cursor/rules/*.md：面向执行代理的目录级规则

## 未来可以扩展
后续可以继续扩展到：
- .github/instructions 的路径级说明
- Claude 的更细分目录记忆
- CI 中的路径级校验
