# System Maturity

## 当前判断
当前系统已经达到“可投入真实使用的通用工作系统基线”阶段。

## 核心稳定层（短期不建议大改）
- 系统母仓库 / 外部项目仓库分离
- knowledge / outputs / logs / docs / config 分层
- project_registry / manifest / system_routes / task_router
- 路径级规则层
- Claude / Copilot / Cursor 分层入口
- 高频入口：
  - start_day.ps1
  - preflight_check.ps1
  - run_maintenance_cycle.ps1
  - close_day.ps1
  - publish_snapshot.ps1
- 项目操作面：
  - project_lifecycle_bootstrap.ps1
  - start_project_work.ps1
  - project_review_cycle.ps1
  - project_status_snapshot.ps1
  - project_ops.ps1
- deliverables layer

## 谨慎变更层
这些部分可以改，但改动前应先想清楚是否会影响现有例行流程：
- system_routes.yaml
- task_router.yaml
- deliverable_types.yaml
- path_rules.yaml
- validate_configs.ps1
- preflight_check.ps1
- project_ops.ps1

## 实验层
这些部分允许继续迭代，但不应影响核心稳定层：
- weekly_maintenance_cycle.ps1 的细节
- deliverable 模板细节
- review / snapshot 模板细节
- 项目启动和项目复盘的内容字段

## 当前不建议继续扩展的方向
- 复杂项目类型体系
- GUI / Web 仪表盘
- 重型 CI / 自动化编排
- 过度细分的代理规则
- 绑定具体行业场景的硬编码模板

## 变更原则
- 先保护核心稳定层
- 新能力优先加在实验层
- 只有真实使用反复证明有价值，才提升为稳定层
- 结构性改动尽量伴随 release snapshot

## 关于样例项目
- 当前已接入的 PsyLens 应视为样例项目，而不是系统默认项目。
- 后续新项目默认从 C:/Users/22358/Desktop/项目 下创建，再通过系统接入。
