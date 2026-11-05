# QUALITY_REVIEW_REPORT

## 身份与基线

- `task_id`: `STAGE21F-quality_reviewer`
- `run_id`: `stage21f-quality_reviewer-001`
- `phase`: 4
- `role_id`: `quality_reviewer`
- Soul: `quality_reviewer` 1.1.0，SHA-256 `de7da8db6e94d862f5b83f9e4dd69f759bd2a3927c6853b062f0a64b44fd5207`（与输入值一致）
- Harness: 请求使用 `codex`；请求模型 `group/gpt-6-luna`。模型服务端实际执行身份未独立验证。
- 目标 Commit: `df21d132ab75c8560c12531b1cf2a6e1aa8a5d39`
- 审查时 `HEAD` 与目标 Commit 一致。规格 `TASK_SPEC.md` SHA-256 为 `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45`，与任务输入一致。规格标为演示夹具；冻结/批准不构成生产审批。
- 权限意图：只读源码与输入；仅在已授权的 `_reports/` 下创建此报告。

## 范围与方法

审查目标 Commit 中的 `toy.py`、`test_examples.py`、`TASK_SPEC.md`，以及作为审查输入的 `defect.diff` 和 `.input/` 下任务、授权、Soul 文件。检查了目标提交元数据和变更、当前 `HEAD`、工作区状态、规格与 Soul 哈希以及相关源码行。未读取工作目录外内容。

未运行测试或构建（`NOT_RUN`）；判决依据为源码与规格的静态比对。没有把测试结果或执行身份推断为已验证。

## 发现

### IMPORTANT — `count_done` 返回元素总数而非 True 元素数

- 位置：`toy.py:2`；同一变更由 `defect.diff:4-6` 明确展示。
- 触发条件：输入含有任意 `False` 元素。
- 证据：规格 `TASK_SPEC.md:2-3` 要求只统计值为 `True` 的元素。当前实现 `len(items)` 对 `[True, False, True]` 返回 3（期望 2），对 `[False]` 返回 1（期望 0）。这是从实现直接推导的静态失败模式；未运行测试。
- 影响：所有含 False 的输入产生错误计数，破坏函数核心契约。现有 `test_examples.py:3-7` 已覆盖这两种输入；如执行，按断言预期会失败。
- 建议验证：实现修正后运行 `test_examples.py` 中的混合列表、全 False 和空列表用例，并增加全 True 输入（例如 `[True, True] -> 2`）以覆盖另一边界。

## 正面验证与未验证事项

- `VERIFIED`: 目标 Commit 是当前 `HEAD`；工作区 `git status` 显示 `.input/` 未跟踪，未发现已跟踪源码改动；针对 `HEAD` 的 `git diff` 为空。
- `VERIFIED`: `TASK_SPEC.md` 与输入 SHA 一致；`.input/SOUL.md` 与输入 Soul SHA 一致。
- `VERIFIED`: 目标提交实际新增 `toy.py`，实现为 `return len(items)`；`defect.diff` 描述的替换与该实现相符。
- `UNVERIFIED`: 未运行任何测试或构建；不存在运行时执行结果或日志可供确认。
- 本次为合成审查，不代表真实生产 Gate 审批。

## 工作记录

在工作目录内执行了以下只读检查（成功退出，退出码 0）：`Get-Location`、`git status --short`、`git rev-parse HEAD`、`git show --no-patch --format=fuller <目标Commit>`、`git ls-tree -r --name-only <目标Commit>`、`git show --stat`、`git show --format= --no-ext-diff --unified=30 <目标Commit>`、`git diff --no-ext-diff --binary HEAD`、`Get-FileHash -Algorithm SHA256`，以及对指定文件的读取和行号检查。随后仅在授权目录 `_reports/` 新建本报告。

## 最终判决

**REQUEST_CHANGES**

理由：发现一项可直接违反函数核心契约的 `IMPORTANT` 缺陷。修复实现并确认相关测试通过后再复审。
