# Stage 3 实施顺序

## 这一阶段要解决的问题

不是继续扩某个项目，而是把母仓库从“模板包”升级成“系统中台”。

## 顺序

### Step 1：先定根目录身份
- 更新 README
- 更新 AGENTS.md
- 明确这是系统母仓库，不是单一项目仓库

### Step 2：建立项目注册表
- 新建 `config/project_registry.yaml`
- 把 PsyLens 作为第一个 pilot_project 登记进去

### Step 3：补系统健康检查
- 先检查系统目录与关键配置文件
- 再检查子项目登记是否完整

### Step 4：接入 tech scout
- 先本地 dry-run
- 再决定是否接 GitHub Actions 定时任务

### Step 5：建立子项目模板
- README.template
- AGENTS.local.template
- project_manifest.template

### Step 6：建立知识层治理规则
- 决定哪些内容回写 Obsidian
- 决定哪些内容只留在 repo

## 当前阶段不做的事
- 不做语音常驻
- 不做远程控制
- 不做 GUI 自动化
- 不把所有子项目都接进来
