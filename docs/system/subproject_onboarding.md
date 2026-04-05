# 子项目接入规范

## 一、目的

任何子项目接入系统前，必须满足：
- 有名称
- 有问题定义
- 有输入输出边界
- 有当前阶段
- 有主目录
- 有执行入口

## 二、接入步骤

### 1. 先登记
在 `config/project_registry.yaml` 中新增项目项。

### 2. 再建目录
在 `projects/` 下建立同名目录，或登记外部路径映射。

### 3. 建 manifest
每个项目都要有一个 `project_manifest.yaml`，用于说明：
- 项目目标
- 主要产物
- 数据敏感性
- 常用脚本
- 当前阶段
- 依赖的 agent / model

### 4. 建局部规则
使用 `AGENTS.local.md` 补充项目内特殊规则，而不是污染系统根规则。

## 三、PsyLens 当前应如何登记

PsyLens 目前应被写成：
- 类型：pilot_project
- 状态：active
- 所属系统：AI_agent_bootstrap_pack
- 主路径：`C:\Users\22358\Desktop\项目\PsyLens_GitHub_Repo\PsyLens`
- 角色：系统试运行与方法验证子项目

## 四、局部规则优先级

优先级建议：
1. 系统根规则
2. 子项目 manifest
3. 子项目 `AGENTS.local.md`
4. 子项目 README

## 五、接入失败的常见原因

- 只有目录，没有 manifest
- 只有想法，没有执行入口
- 本地路径固定写死但没有登记
- 子项目把系统级规则复制一遍，导致后续失控
