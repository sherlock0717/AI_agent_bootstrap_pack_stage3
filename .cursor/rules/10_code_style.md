---
description: Coding and debugging rule
globs: ["scripts/**/*.py", "*.py"]
alwaysApply: false
---

Python 脚本规则：
- 优先使用 argparse
- 优先打印关键统计
- 出现网络失败时，保留 URL、状态码、异常信息
- 出现解析失败时，尽量保存原始片段到 debug 目录
- 不要把本地私密路径硬编码进脚本
- 所有 DataFrame 输出前尽量保证列顺序稳定
- 变更字段名时，必须同步告知下游影响
