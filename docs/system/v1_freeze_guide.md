# V1 Freeze Guide

## 当前结论
这套系统已经达到“可正式投入真实使用的通用工作系统基线”阶段。

当前主策略：
- 以真实使用为主
- 以小修补为辅
- 不再继续做大规模系统重构

---

## 一、V1 冻结边界

### 1. 核心定位（冻结）
- 这是 AI 工作系统母仓库，不是单一项目代码仓库
- 系统母仓库负责规则、配置、知识、交付物、例行流程
- 外部项目真实代码继续保留在外部项目目录
- 当前系统目标是支持未来更广范围的工作项目，而不是绑定当前少数项目类型

### 2. 核心结构（冻结）
以下结构当前视为 V1 核心稳定层：
- config/
- scripts/
- knowledge/
- outputs/
- logs/
- docs/
- projects/
- deliverables/

### 3. 当前工作区（冻结）
- 系统母仓库：C:/Users/22358/Desktop/系统/AI_agent_bootstrap_pack_stage3
- 默认外部项目根目录：C:/Users/22358/Desktop/项目

### 4. 关于 PsyLens（冻结口径）
- PsyLens 是当前已接入的**样例项目**
- PsyLens 不是系统本体
- PsyLens 不是默认项目
- 后续新项目默认应从 C:/Users/22358/Desktop/项目 下创建，再通过系统接入

---

## 二、当前高频正式入口

### 系统级入口
- scripts/preflight_check.ps1
- scripts/start_day.ps1
- scripts/run_maintenance_cycle.ps1
- scripts/weekly_maintenance_cycle.ps1
- scripts/close_day.ps1
- scripts/publish_snapshot.ps1
- scripts/system_release_snapshot.ps1

### 项目级入口
- scripts/project_lifecycle_bootstrap.ps1
- scripts/create_project_in_workspace.ps1
- scripts/start_project_work.ps1
- scripts/project_review_cycle.ps1
- scripts/project_status_snapshot.ps1
- scripts/project_ops.ps1

### 交付物层入口
- scripts/init_project_deliverables.ps1
- scripts/new_deliverable.ps1
- scripts/list_project_deliverables.ps1

---

## 三、当前日常使用方法

### 每天开始前
1. 运行：
   .\scripts\preflight_check.ps1
2. 如果通过，再运行：
   .\scripts\start_day.ps1 -SessionTitle "今天的系统工作"

### 进入某个项目
优先使用：
.\scripts\project_ops.ps1 -Action "start" -ProjectName "<ProjectName>" ...

### 新建项目
优先使用：
.\scripts\create_project_in_workspace.ps1 ...
或
.\scripts\project_lifecycle_bootstrap.ps1 ...

### 查看项目状态
优先使用：
.\scripts\project_ops.ps1 -Action "status" -ProjectName "<ProjectName>"

### 做项目复盘
优先使用：
.\scripts\project_ops.ps1 -Action "review" -ProjectName "<ProjectName>"

### 生成交付物
优先使用：
.\scripts\project_ops.ps1 -Action "deliverable_new" -ProjectName "<ProjectName>" ...

### 每天结束
1. 运行：
   .\scripts\close_day.ps1 -DecisionTitle "今天形成的关键决定"
2. 再运行：
   .\scripts\publish_snapshot.ps1 -Message "chore: update daily system state"

### 每周维护
运行：
.\scripts\weekly_maintenance_cycle.ps1 -WeeklyReviewTitle "本周维护回顾" -ScoutReviewTitle "本周技术雷达复盘"

---

## 四、DeepSeek API 的 V1 固定用法

### 当前默认供应商
V1 默认主供应商：DeepSeek API。

### 当前原则
- 日常默认模型：deepseek-chat
- 复杂推理、复杂调试、结构判断：deepseek-reasoner
- 默认优先采用 OpenAI-compatible 接入方式
- 结构化输出优先使用 JSON 输出模式
- 需要更严格工具调用时，再考虑 beta / strict 模式

### 当前不做的事
- 不在 V1 中频繁切换主模型供应商
- 不在 V1 中复杂化多供应商编排
- 不在 V1 中大量增加 provider-specific 特判逻辑

---

## 五、当前不建议继续扩的方向

以下方向当前列入“延后层”：
- 复杂项目类型体系
- GUI / Web 仪表盘
- 重型 CI / 自动化编排
- 过细的 agent 规则继续分裂
- 更重的 schema 引擎
- 绑定具体行业的大量硬编码模板

---

## 六、V1 之后的改动原则

### 可以继续做的
- 小范围修补
- 高频使用中的真实痛点修复
- 基于真实项目反复出现的问题，升成系统能力

### 暂时不要做的
- 没有真实使用痛点的扩建
- 为了“更强大”而继续横向堆功能
- 推翻当前核心稳定层的大改造

### 判断标准
一个新能力只有在以下情况之一满足时，才值得升到系统层：
- 你已经连续 2 到 3 次手工做同一件事
- 你已经连续 2 到 3 次在同一处出错
- 你明显需要一个统一入口，否则会影响日常使用效率

---

## 七、当前阶段判断

当前系统已适合正式投入真实项目使用。
系统搭建从主线降为副线。
后续原则：
- 主线：用系统做真实工作
- 副线：根据真实使用反馈做小修补
