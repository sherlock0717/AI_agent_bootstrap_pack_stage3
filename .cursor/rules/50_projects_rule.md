# Projects Rules

## 适用范围
- projects/**

## 目标
这里保存外部项目的接入登记点，而不是项目真实代码仓库。

## 编写原则
- project_manifest.yaml 应与 project_registry.yaml 保持一致
- AGENTS.local.md 应与 manifest 描述一致
- README 应说明这是接入点，不是真实代码仓库
- 新项目优先通过 onboarding 脚本或模板接入
- projects 目录只保存接入信息、局部规则、项目说明
- 外部项目真实代码应继续留在外部仓库

## 不要这样做
- 不要把项目真实代码复制进 projects/
- 不要让 manifest、README、AGENTS.local 三者信息漂移
- 不要绕开模板随意新建项目接入目录
