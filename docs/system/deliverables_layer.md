# Deliverables Layer

## 目的
交付物层用于管理系统支持的“最终输出物”，而不是过程性知识或临时运行结果。

## 为什么需要这一层
当前系统已经有：
- knowledge：长期沉淀
- outputs：临时输出
- logs：运行日志
- docs：稳定说明
- config：控制配置

但还缺少一个专门面向“交付物”的结构。
未来无论项目类型怎么变化，大多数项目最终都要形成某种交付物。

## 当前原则
- deliverables/ 用于保存交付物草稿与正式稿
- deliverables 不等于 knowledge
- deliverables 不等于 outputs
- 交付物可以来自项目，但不一定属于项目代码仓库
- 交付物层应尽量保持类型通用，而不是过早绑定行业类别

## 当前结构
- deliverables/projects/<ProjectName>/
- templates/deliverables/
- config/deliverable_types.yaml

## 当前策略
- 先做通用交付物类型
- 不在这一步把交付物路径强行写进 manifest
- 等这层稳定后，再考虑和 manifest / schema 做更深整合
