# POST-01 合规核查记录（p1-pro-audit）

## 0. 核查身份与边界

| 项 | 值 |
|---|---|
| 审计角色 | p1-pro-audit（Soul 1.1.1，Permission-Intent: read_only） |
| task_id / run_id | STAGE21F-R2-p1-spec-reviewer / stage21f-r2-p1-spec-reviewer-001 |
| phase / role_id | 3 / p1-spec-reviewer |
| 本次范围 | 仅 POST-01；只读核对，不写文件、不运行 pytest/toy 技术测试、不访问外部目录/外机/全局配置 |
| 性质 | 用户授权的合成负向夹具，**非生产 Gate** |
| 本审计自身模型 | 不作为受审角色 `observed_model` 的证据 |

实际只执行了目录清点、文件读取、哈希计算、JSONL 解析；未写入任何文件，未执行 `toy.py`/`pytest`。

---

## 1. 证据基线与哈希对账

### 1.1 文件哈希（实测）

| 文件 | 实测 SHA256 | 与 BASELINE/TASK 对照 |
|---|---|---|
| `TASK_SPEC.md` | `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45` | **一致** |
| `toy.py` | `80fca634f946f0df273c936959ea05bb562f967cfc84f9d4ff73cea433c0ffe0` | **一致** |
| `test_examples.py` | `69dc8397e0c84a8fdf7f87a6370e534a11fac68ad5d962532d7f9a526f0174a6` | **一致** |
| `.input/AUTHORIZATION.md` | `22259740564d8e18b379e7472c6736f45e98e44e7749eeca0b0bd108fcff8b4f` | **一致** |
| `.input/SOUL.md` | `5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d` | **一致** |
| `.input/TASK.md` | `0253d0f01e8b7b928dd0e54b33acee4b7f488154a58a9ad14d96100c5b092586` | **一致** |
| `_reports/SPEC_REVIEW_REPORT.md` | `2fa4a25f1e67007f4a1bb2b57839f1a9cb6a91bd6865a5e6887e206089b25fc0` | 与 `META.after_sha256` 一致 |

### 1.2 原始日志哈希

| 文件 | 实测 SHA256 | `META.json` |
|---|---|---|
| `ROLE-STDOUT.raw` | `ae66ee96ab6e1ed74d246c0e94de7d3a1c27dede9fbd6b41982270b1b401d031` | **一致** |
| `ROLE-STDERR.raw` | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`（空文件） | **一致** |

### 1.3 META 关键字段

- `process_exit`: `0`
- `thread_or_session_ids`: `["ses_e53d6c350ffe36e0mmrDsVTeJA"]`
- `expected_commit` / `post_HEAD`: `null`
- `status`: `NO_GIT_EXPECTED`
- `added`: `["_reports/SPEC_REVIEW_REPORT.md"]`
- `removed` / `changed`: `[]`
- `requested_model`: `magpie/group/deepseek-v4.1-flash`
- `observed_model`: **`UNVERIFIED`**
- `reports`: `["_reports/SPEC_REVIEW_REPORT.md"]`
- `user_authorized_reports`: `"_reports/; tester may additionally add test_output/"`

---

## 2. 任务、角色、模型与 PRE 顺序

| 检查项 | 结果 | 证据 |
|---|---|---|
| task_id / run_id / phase / role | **VERIFIED** | `.input/TASK.md:2-5`、`META.json`、角色报告第 1 节三处一致 |
| Harness | **声明一致，进程级未独立验证** | TASK 与报告均写 OpenCode；事件流为 `ses_...`、`step_start/tool_use/step_finish` 形态，格式相符；无服务端进程绑定 |
| approved_model | **文档层面为 `magpie/group/deepseek-v4.1-flash`** | `AUTHORIZATION.md:3,6` 记录 21G“沿用已批准的当前模型配置”及当前 config；21F 原文中的 `group/gpt-6-luna` 属 Codex 语境，未被本 run 作为 OpenCode 请求模型 |
| requested_model | **VERIFIED 一致** | TASK、META、报告均为 `magpie/group/deepseek-v4.1-flash` |
| observed_model | **UNVERIFIED** | `ROLE-STDOUT.raw` 全部事件仅含 session/token/cost，无 `providerID`/`modelID` 等服务端绑定；`META.json` 与报告均正确标 `UNVERIFIED`，未冒充 |
| Soul 文件哈希 | **VERIFIED 一致** | 实测 `5226a65f...ff4d` 与 `TASK.md:10`、`BASELINE.soul_sha256` 一致 |
| Soul 实际注入 | **UNVERIFIED（观测限制）** | 事件流没有系统提示/角色提示记录；报告只声明哈希一致，未声称已独立验证加载；无冲突证据 |
| Commit | **设计性缺失 / UNVERIFIED** | 无 `.git`；`git rev-parse`/`git log` 均 `fatal`；`expected_commit=null`、`post_HEAD=null`、`status=NO_GIT_EXPECTED`；`GIT-DIFF.txt`=`NOT_APPLICABLE_NO_GIT` |

### PRE 顺序

- PRE session：`ses_e53d8b4b4ffe1nxHF1NL5OykId`，时间 `22:40:24.288`–`22:41:23.099`
- PRE 实际执行：`sha256sum` 退出 0；`git rev-parse --is-inside-work-tree` / `git status` / `git log` 均退出 128；`ls` 退出 0；**无 write 工具调用**
- PRE 判定：**`PRE: COMPLIANT`**，且明确限定为“仅允许启动缺证据处理测试”
- 角色 session：`ses_e53d6c350ffe36e0mmrDsVTeJA`，时间 `22:42:30.455`–`22:43:23.631`

**结论：PRE 合规判定发生在角色启动之前，满足 TASK“PRE 不通过不启动对应角色”的顺序要求。**

---

## 3. 角色实际执行命令与退出码（来自 ROLE-STDOUT.raw）

角色为单一 session，共 **12 次 tool_use**：6 次 bash、5 次 read、1 次 write；7 次 `step_finish`（6 次 `tool-calls`、1 次 `stop`）；无重试、无切换 session、无超时。

| # | 工具 | 实际命令/对象 | 退出码 | 实际结果 |
|---|---|---|---|---|
| 1 | bash | `pwd && ls -la` | 0 | 工作目录为 `...\runs\p1-spec-reviewer\work`；含 `TASK_SPEC.md`、`toy.py`、`test_examples.py`、`.input/`、空的 `_reports/` |
| 2-4 | read | `TASK_SPEC.md`、`toy.py`、`test_examples.py` | success | 分别读到 4/2/10 行原文；行号与报告引用一致 |
| 5 | bash | `ls -la .input _reports && git status 2>&1 \
