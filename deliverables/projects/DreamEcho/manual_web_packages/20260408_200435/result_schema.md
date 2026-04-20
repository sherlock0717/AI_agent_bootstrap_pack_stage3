# 网页返回结构规范

顶层字段：
- channel: 必须为 manual_web
- scenario: 固定为任务包中的场景名
- project: 项目名
- summary: 一句话总结
- tasks: 数组

tasks[i] 字段：
- task_id: 字符串，项目内唯一
- task_name: 字符串
- priority: P0/P1/P2
- description: 字符串
- depends_on: 字符串数组（可空）
- suggested_executor: native_script/openclaw
- suggested_channel: deterministic/api/manual_web/openclaw_proxy
