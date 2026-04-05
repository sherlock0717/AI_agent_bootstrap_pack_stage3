# Project Lifecycle Bootstrap

## 目的
这个入口用于把“项目接入、交付物初始化、初始工作启动”收束成一个更完整的生命周期起点。

## 为什么需要它
当前系统已经有：
- onboarding 脚本
- deliverables 初始化
- deliverable 创建
- project work start
- project review cycle

但这些仍然是分散入口。
对于新项目来说，更高频的需求是“一次完成项目起步”。

## 当前设计
project_lifecycle_bootstrap.ps1 用于处理这些通用起步动作：
- 注册外部项目
- 初始化交付物目录
- 可选创建 brief
- 可选创建 plan
- 可选启动第一次项目工作

## 原则
- 保持通用，不绑定特定行业或项目类型
- 支持 DryRun
- 真实项目仍然是外部仓库
- 系统母仓库只保存接入、知识、规则、交付物和流程信息
