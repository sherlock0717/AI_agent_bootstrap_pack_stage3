# Asset Boundary

## 目的
这份文档用于明确系统中“运行输出”和“长期资产”的边界，避免后续文件放置混乱。

## 分类原则

### outputs/
用于保存运行时产生的临时结果、一次性输出、快照文件。
特点：
- 可能很多
- 不一定需要长期保存
- 默认不作为长期知识资产管理
- 默认不进入 Git 的长期追踪范围

典型内容：
- health check 输出
- scout manual run 输出
- daily dashboard 原始输出
- 一次性脚本运行结果

### knowledge/
用于保存值得长期保留、后续会再次引用的内容。
特点：
- 需要长期留存
- 应该可以被回看、引用、复盘
- 属于系统记忆的一部分
- 可以进入 Git 追踪

典型内容：
- system notes
- project notes
- decisions
- sessions
- weekly reviews
- scout reviews
- 被提升后的 dashboard 归档

### logs/
用于保存运行日志与诊断信息。
特点：
- 更偏技术记录
- 主要服务于排错和追踪
- 不等于知识资产

### docs/
用于保存面向人阅读的稳定说明文档。
特点：
- 更偏说明和规范
- 不等于运行输出

### config/
用于保存系统控制配置。
特点：
- 直接影响系统行为
- 应尽量保持字段清晰与结构稳定

## 当前策略
- dashboard 先生成到 outputs/dashboards/
- 只有确认值得长期保留时，才提升到 knowledge/system/dashboards/
- scout 也是类似逻辑：先输出，再提升
- 不把所有运行结果都直接放进 knowledge

## 判断标准
如果一个文件满足以下任一条件，更适合进入 knowledge：
- 后续会再次引用
- 代表某次阶段性状态
- 能帮助后续决策
- 属于系统经验沉淀
- 不只是一次性运行副产物
