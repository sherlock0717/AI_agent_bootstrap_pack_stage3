# Operating Routines

## 目的
这份文档用于说明系统在日常使用中的高频例行流程。

## 当前核心例行流程

### 1. 系统日启动
适用场景：
- 开始一天的系统工作
- 先检查系统状态，再记录当天会话

入口：
- scripts/start_day.ps1

### 2. 项目工作启动
适用场景：
- 今天要进入某个具体项目
- 需要先做任务路由，再创建项目会话

入口：
- scripts/start_project_work.ps1

### 3. 日常维护巡检
适用场景：
- 想检查系统结构是否仍然稳定
- 想顺手刷新索引、生成 dashboard、做归档 dry-run

入口：
- scripts/run_maintenance_cycle.ps1

## 例行原则
- 高频入口尽量少而清楚
- 不要求每次都手动拼装很多命令
- 复杂脚本可以继续存在，但日常优先用少数标准入口
- 如果某个脚本成为高频入口，应考虑写入 system_routes.yaml
