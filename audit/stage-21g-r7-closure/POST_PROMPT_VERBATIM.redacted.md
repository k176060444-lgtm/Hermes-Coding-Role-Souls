# R7 POST 派发书原文（脱敏）

SHA256（原始文件）: 5c68c6f3f245e48423a6431a613af23181cfbd37587bb377a9ac7fea68630ac7

以下为除本地用户目录占位符外的逐字原文，供独立核对停线条款缺失。

```text
你是既有 OpenCode `p1-pro-audit`，对 `stage21g-r7-tester-a-001` 做唯一一次 POST；只基于本次原始事实，不重跑测试、探针或其他角色，不联网、不改任何文件。

工作目录为当前 R6 Tester worktree。材料位于 `.audit/tester-a-r7/post/`：`META.json`、`BEFORE.json`、`AFTER.json`、`ROLE.stdout`、`ROLE.stderr`、`ROLE.exit`、`INVOCATION_ACTUAL.json`；本轮 PRE 原始事件和回执在 `.audit/tester-a-r7/PRE.jsonl` 与 `PRE_RECEIPT.json`；TASK、Soul、用户授权、MERGE 在 `.audit/tester-a-r7/`；规格和原始代码在项目根；正式考卷、测试代码、测试报告和日志在 `tests_gate_a/`。

逐个基于原始 Codex JSONL 的 `item.id` 核验命令、退出码、完整输出、写入与访问范围，不混同不同命令或测试子进程/外壳退出码。特别区分：角色 `turn.completed/turn.failed`；真实 `python -m unittest` 调用、测试进程显式退出码及 `Ran/OK/FAIL/ERROR`；临时夹具与目录外写入；三份角色交付物和自建测试；Spec/Quality 合并材料是否同一 Commit/规格；固定文件 SHA 和文件增删改。必须实际读取 UTF-16 测试日志并核验，不得用报告自述代替；仅测试执行信息为证据，Worker 的旧测试不得替代。

`item_23` 含真实 unittest 命令与其保存的 `$LASTEXITCODE`，PowerShell 自身退出码也是单独事实；`item_26` 是无效 UTF-8 独立观察，区分目标 CLI 退出码和探针外层退出码；`item_29` 是一次读取日志为 UTF-8 的只读核验失败，须独立报告，不能误记为 unittest 失败。之后如有其他测试相关命令必须分别核对。

请核对 `INVOCATION_ACTUAL.json` 的 `-ProxyUrl`、大小写代理变量与 role 事件的关系，不把计划误当上游可用性的证明；如角色实际执行命令，按实际事件说明已进入角色执行。无效 UTF-8 按冻结规格判定，不预先提升为 BLOCKER。

META 中受控配置变更为调度端发现的 Codex trusted 记录候选；审计仅记录现场哈希和取证限制，不读取整个用户配置内容、不修改配置。调度端会单独备份、证明差异并按授权处理。PRE 原始 COMPLIANT 应保留；PRE 读自身 PRE_PROMPT 并列出 `.audit` 名称的只读范围观察，单独记录，不能虚构其他私有文件读取。

POST 最后必须给出明确 `POST: COMPLIANT`、`POST: NON_COMPLIANT` 或 `POST: UNVERIFIED`，指出关键事实不符及对 Gate A 的影响。`observed_model`、服务端身份、未独立证明的运行时 Soul 注入保持 UNVERIFIED。不得把本地 TEST_ONLY 描述成生产审批。

```
