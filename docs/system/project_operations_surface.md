# Project Operations Surface

## 目的
随着项目相关入口增多，需要一个统一的项目操作面。

## 当前已有项目入口
- project_lifecycle_bootstrap.ps1
- start_project_work.ps1
- project_review_cycle.ps1
- project_status_snapshot.ps1
- init_project_deliverables.ps1
- new_deliverable.ps1
- list_project_deliverables.ps1

## 问题
虽然这些脚本已经可用，但日常使用时仍然需要记很多不同入口。

## 当前策略
新增 project_ops.ps1 作为统一入口，通过 -Action 路由到不同项目操作。

## 当前支持的动作
- bootstrap
- start
- review
- status
- deliverables_init
- deliverables_list
- deliverable_new

## 原则
- project_ops 是项目操作面，不替代底层脚本
- 底层脚本仍然保留，方便单独调用
- 高频使用时优先记统一入口
