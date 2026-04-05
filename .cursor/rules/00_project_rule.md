---
description: Global project rule for Cursor
globs: ["**/*"]
alwaysApply: true
---

这是一个 AI 辅助研究与洞察工作流仓库。

你在这个仓库中工作时必须遵守：
1. 先理解现有脚本链路，再改代码。
2. 优先最小修改，不要无理由重构整个项目。
3. 任何抓取脚本都要保留失败日志和 debug HTML。
4. 任何洞察输出都要能回链 evidence。
5. 不要把探索性机制假设写成确定性事实。
6. 修改 scripts/ 时，优先保持命令行参数兼容。
7. 新增文件后，如影响流程，请同步更新 docs/workflow.md。
