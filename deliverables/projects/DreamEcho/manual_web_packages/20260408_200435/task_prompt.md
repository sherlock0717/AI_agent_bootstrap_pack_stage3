# 网页协作任务包

- 项目：DreamEcho
- 场景：new_project_first_pass
- 推荐通道：manual_web
- 允许回退：是

## 本次任务目标
- 为当前项目生成“首轮任务清单候选”，用于后续导入系统做结构化校验。

## 可参考上下文（系统已筛选）
manual_web_collab（execution_feedback_focus_decision）：AI 推荐 知识复用提示；最终采用 项目状态摘要、本期焦点摘要、知识复用提示；已兜底；基线=项目状态摘要、本期焦点摘要、知识复用提示。

## 不需要参考的对象
- 全量历史 trace
- 全量知识库全文
- 无关历史建议全文

## 输出要求（必须严格）
1. 仅返回 JSON（不要包含解释性正文）
2. 顶层字段必须包含：channel/scenario/project/tasks/summary
3. 每条任务必须包含：task_id/task_name/priority/description
4. 建议补充：depends_on/suggested_executor/suggested_channel
5. suggested_channel 仅允许：deterministic/api/manual_web/openclaw_proxy

## 导入说明
- 将网页返回 JSON 保存为文件后，在项目中心“网页协作通道”中点“导入网页结果”。
- 系统会先写入“导入候选”，校验通过后再由你确认写入 task_manifest。
