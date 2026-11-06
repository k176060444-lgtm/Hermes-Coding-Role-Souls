# POST 审计 — `stage21g-r7-tester-a-001`（Phase 4.5 / `tester_gate_a`）

## 0. 身份、动作与限制

| 项目 | 内容 |
|---|---|
| 审计角色 | 既有 OpenCode `p1-pro-audit`（Soul 1.1.1，read_only） |
| 任务 | 仅对 `stage21g-r7-tester-a-001` 做一次 POST |
| 工作目录 | `<LOCAL_USER_HOME>\Stage21G-R6\tester`（R6 Tester worktree） |
| 本次动作 | 只读读取案卷、原始 Codex JSONL、原始 UTF-16 日志、BEFORE/AFTER、PRE 原始事件与回执；未重跑 unittest/探针、未启动任何角色、未联网、未写入/修改任何文件 |
| 取证补强 | 仅以只读方式用 Python UTF-16 解码及 PowerShell `Get-Content` 读取既有测试日志；未重跑测试、未创建文件 |
| 判决依据 | 原始事件、真实退出码、UTF-16 日志、哈希与文件增删改，不以角色报告自述代替 |

---

## 1. 材料与固定哈希核验

独立重算（`sha256`），与 META/BASELINE/MERGE/PRE 回执逐项一致：

| 文件 | 实测 SHA256 | 对照 | 判定 |
|---|---|---|---|
| `ROLE.stdout` | `fe90c801…f9f49f5` | META | VERIFIED |
| `ROLE.stderr` | `1ebf1e1e…ce81d06` | META | VERIFIED |
| `ROLE.exit` | `5feceb66…fb57e9`（内容 `"0"`） | META `role_exit=0` | VERIFIED |
| `INVOCATION_ACTUAL.json` | `cdd2e650…bb82af4` | META | VERIFIED |
| `BEFORE.json` / `AFTER.json` | `ee585c50…5664905` / `a6a73e14…57a7bbb` | META | VERIFIED |
| `.audit/tester-a-r7/TASK.md` | `6b083a25…a6db9a4` | BASELINE | VERIFIED |
| `USER_AUTHORIZATION.md` | `2afbb2af…706f422` | BASELINE | VERIFIED |
| `SOUL.md` | `e2530a2b…1094e98a` | TASK/BASELINE | VERIFIED |
| `MERGE.json` | `4216ed10…3c660fc` | BASELINE | VERIFIED |
| `SPEC_REVIEW_REPORT.md` | `6a0daabd…058aa3` | MERGE.spec | VERIFIED |
| `QUALITY_REVIEW_REPORT.md` | `e26408f0…e81fd7d` | MERGE.quality | VERIFIED |
| `R6_HISTORY.json` | `6677fed4…caca52dd` | BASELINE | VERIFIED |
| `PARAMETERS.json` / `INVOCATION.json` | `e53fb891…726ad6f` / `0808924b…19694a` | BASELINE | VERIFIED |
| `PRE.jsonl` / `PRE_RECEIPT.json` | `8ec28d68…fd9c4` / `e615b53b…0828114` | META/BASELINE | VERIFIED |
| `TASK_SPEC.md` | `dafc4a31…e8258c` | TASK/MERGE/FREEZE | VERIFIED |
| `TEST_ONLY_FREEZE.md` | `bb1fe989…84ce63c` | TASK/MERGE | VERIFIED |
| `inventory.py` / `test_inventory.py` | `29c48172…5f84e4` / `fc1d6a83…d20d788` | SPEC/PRE | VERIFIED |

- 固定 Commit：`a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`，与 `git rev-parse HEAD`、TASK、MERGE 一致。
- `git diff --exit-code -- inventory.py test_inventory.py TASK_SPEC.md TEST_ONLY_FREEZE.md` 退出码 `0`（无差异）。
- 当前 `git status --short` 仅有 `?? .audit/`、`?? tests_gate_a/`，无已跟踪文件修改。

---

## 2. PRE 保留记录（不作为本轮重新审批）

- `PRE_RECEIPT.json`：`run_id=stage21g-r7-tester-a-001`、`session_id=ses_e506a9f73ffe7UT6nZBy7K5qmS`、`exit=0`、`finish_reason=stop`、`original_verdict="PRE: COMPLIANT"`；`source/copied_sha256=8ec28d68…`（实测 `PRE.jsonl` 同哈希）。
- `PRE.jsonl`：60 个事件；事件类型仅 `step_start / step_finish / text / tool_use`；仅会话 `ses_e506a9f7…`；最终 text 事件（第 58 号）包含 `**PRE: COMPLIANT**`。
- PRE 工具仅 `bash`、`read` 两类；命令为 `ls / sha256sum / git rev-parse / git status / git diff / git cat-file / git worktree list / grep / python -c 只读解析`；未见写入型命令（`2>&1` 仅为流重定向，非文件重定向）、未见文件编辑工具。
- **PRE 原始 COMPLIANT 保留**，本轮不推翻。

**PRE 只读范围观察（单独记录，OBSERVATION）**：PRE 的 `read` 事件 17 读取了自身 `PRE_PROMPT.txt`（该文件不在其提示词第 3 行列出的可读清单内）；事件 1/2/26 列出 `.audit/`、`.audit/tester-a-r7/` 名称，事件 26 仅列出 `.audit/tester-a-r6/` 的**文件名**。未发现改写文件；未发现读取 `tester-a-r6` 的文件内容。`R6_POST.jsonl`、`R6_ROLE.stdout` 属 PRE_PROMPT 第 3 行明确允许的案卷材料[^1]。

[^1]: 该判断基于对 `PRE_PROMPT.txt` 文本的只读核对（第 3 行明列 `R6_ROLE.stdout`、`R6_POST.jsonl`）。

---

## 3. 角色实际执行的 POST 核验（逐 `item.id`）

`ROLE.stdout` 共 59 行：第 1 行为 helper 前导非 JSON（`Role=tester_gate_a Soul=…\tester_gate_a.md SHA256=E253…E98A Execute=True`），其余 58 个 JSON 事件。`thread.started` = `01a1afa4-6686-7873-91f9-e2253f8f3cec`（与 META `thread_id` 一致）；`turn.started` ×1；`turn.completed` ×1（末事件，usage input 876135 / output 9450）；**无 `turn.failed`**。

### 3.1 命令级事实表（13 次 command_execution + 2 组 file_change）

| item.id | 命令要点 | 退出码/状态 | 输出证据 | 写入/访问范围 |
|---|---|---|---|---|
| item_1 | `git status/rev-parse/show`、`rg --files` | 0 / completed | 239B；HEAD 一致；`?? .audit/` | 只读 worktree |
| item_4 | 列 `.audit/tester-a-r7`、`Get-FileHash` 规格/Soul、`Get-Content` 8 份案卷（含 PRE.jsonl） | 0 / completed | 264274B | 只读 `.audit/tester-a-r7` |
| item_6 | 独立 `sha256` 案卷、解析 PRE 事件、列 `tests_gate_a` | 0 / completed | 2729B；记录 PRE 事件数/SESSION/类型 | 只读 |
| item_8 | 读 `TASK.md`、筛选 PRE 文本 | 0 / completed | 5193B | 只读 |
| item_10 | 读 PRE 末事件文本 | 0 / completed | 3575B（含 `PRE: COMPLIANT`） | 只读 |
| item_13 | 读 TASK_SPEC/FREEZE、`rg --files` | 0 / completed | 4097B | 只读 |
| item_15 | 读 `inventory.py`、`test_inventory.py` | 0 / completed | 6138B | 只读代码 |
| item_17 | `rg` 双审报告中边界/UTF-8 条目 | 0 / completed | 3659B | 只读案卷 |
| item_20 | `file_change` 新增 `TEST_A_CASES.md`、`test_gate_a_inventory.py` | completed | 2 add | 仅 `tests_gate_a/` |
| item_23 | **真实 `python -m unittest discover -s tests_gate_a -p 'test_*.py' -v`** `*> unittest.log`；保存 `$testExit=$LASTEXITCODE`；`exit 0` | **0 / completed** | 2275B；`EXIT_CODE=0` | 写 `tests_gate_a/unittest.log` |
| item_26 | 无效 UTF-8 探针：`subprocess.run([sys.executable,'inventory.py',…])` `*> utf8_observation.log`；保存 `$probeExit`；`exit $probeExit` | **0 / completed** | 585B；`RETURN_CODE: 1`、`STDOUT_REPR: ''`、`PROBE_EXIT_CODE=0` | 写 `tests_gate_a/utf8_observation.log`；夹具在 `tests_gate_a/tmp`（TemporaryDirectory 自动清理） |
| item_29 | `Get-FileHash` 4 份交付/日志 + `git status` + `git diff` + `rg inventory.py` + **以 UTF-8 读取 UTF-16 日志** | **1 / failed** | 1286B；前序输出在；末尾 `UnicodeDecodeError: 'utf-8' codec can't decode byte 0xff in position 0` | 只读；**非 unittest 失败** |
| item_31 | 以 `encoding='utf-16'` 读同一日志并统计 | 0 / completed | 61B：`tests=11 failures=0 errors=0`、`Ran 12 tests in 0.175s`、`OK` | 只读 |
| item_33 | `file_change` 新增 `GATE_A_REPORT.md`、`TEST_A_EVIDENCE.md` | completed | 2 add | 仅 `tests_gate_a/` |
| item_36 | 递归列 `tests_gate_a`、`Get-FileHash` 8 文件、`git status`、`git diff --exit-code`、`rg` 报告 | 0 / completed | 2592B；`git diff --exit-code` 通过 | 只读 |

- META `completed_command_count=13` 与 13 个 `item.completed / command_execution` 一一对应。
- 另有两个 `agent_message` 汇报与若干 `reasoning`，无其他工具类型（无 web、无 patch/edit 工具）。

### 3.2 关键命令分项核验

**item_23（真实 unittest，退出码分离）**
- 命令确为 `python -m unittest discover -s tests_gate_a -p 'test_*.py' -v`，`$ErrorActionPreference='Continue'`，设置 `PYTHONDONTWRITEBYTECODE=1`、`PYTEST_ADDOPTS=-p no:cacheprovider`、`TEMP/TMP/TMPDIR=tests_gate_a/tmp`。
- `$LASTEXITCODE` 在 `Get-Content` 之前捕获并打印 `EXIT_CODE=0`；PowerShell 自身退出码是单独的 `exit 0`（item 退出码 0）。二者均已分别记录，未混同。
- `item_23.aggregated_output` 与磁盘 `unittest.log`（UTF-16LE BOM）解码结果逐字符比对：日志为输出前缀，尾部附加 `EXIT_CODE=0`（2262 vs 2275 字符），证明展示内容即本次落盘日志。

**实际 UTF-16 日志核验（必做项）**
- `tests_gate_a/unittest.log`：首字节 `FF FE`（UTF-16LE BOM），4526 字节；实测 SHA256 `4c2497aa…97ce548`（与 AFTER、item_29 `Get-FileHash` 一致）。
- 解码内容：12 条测试用例（`test_gate_a_inventory.InventoryGateATests.*`）全部 `... ok`；`Ran 12 tests in 0.175s`；`OK`；无 `FAIL`、无 `ERROR`。
- 该日志只含**新建测试文件**的 12 项测试，不含 Worker 旧 `test_inventory.py` 的 14 项，符合“旧自测不得冒充 Gate A”。
- 测试文件共 12 个 `test_*` 方法（`test_empty_file_and_blank_record_fail_without_output` 内用 `subTest` 覆盖空文件与空行两例，仍计 1 项），与 `Ran 12 tests` 吻合。

**item_26（无效 UTF-8 观察，目标 CLI 与探针退出码分离）**
- 探针外层 `PROBE_EXIT_CODE=0`；目标 CLI `RETURN_CODE: 1`；`STDOUT_REPR: ''`；stderr 为未捕获 `UnicodeDecodeError` 回溯（`inventory.py:27` 表头解码）。
- `utf8_observation.log`：UTF-16LE BOM，1134 字节，实测 SHA256 `44befaad…e0574`（与 AFTER 一致）；解码内容与 item_26 输出前缀逐字符一致，尾部附加 `PROBE_EXIT_CODE=0`（566 vs 585 字符）。
- 分类：这是独立观察，**不是 Gate 失败**；冻结规格只承诺 UTF-8 输入，未定义非法字节的诊断契约，双审亦分别标为 OPTIONAL/FYI；按用户要求不预先提升为 BLOCKER。

**item_29（只读核验失败，独立记录）**
- `Get-FileHash` 四份文件哈希分别为 `FBD0ABB2…`、`4DF918B3…`、`4C2497AA…`、`44BEFAAD…`，均与 AFTER 一致；`git diff` 无输出；`rg` 命中 `inventory.py:13/25/62`（无 `UnicodeDecodeError` 处理）。
- 失败点仅在最后一步：`python -X utf8 -c "...read_text(encoding='utf-8')..."` 读取 UTF-16LE 日志，在 position 0 遇 `0xFF` 抛 `UnicodeDecodeError`，导致整条命令退出 1。
- **不能记为 unittest 失败**：该命令未调用 unittest，未改变测试结果；角色随后在 item_31 用 `encoding='utf-16'` 成功读取。
- 只读补证：PowerShell `Get-Content -Encoding UTF8` 可显示该日志（PowerShell 处理 BOM 行为与 Python `read_text(encoding='utf-8')` 不同），解释了 item_23 展示可读而 item_29 Python 读取失败，二者不矛盾。

**item_31**
- 输出 `tests=11 failures=0 errors=0`：正则按行尾匹配时，受 PowerShell `NativeCommandError` 换行影响少计 1 条；但同输出含 `Ran 12 tests in 0.175s` 与 `OK`，角色最终按 `Ran 12` 报告 12 项，未造成虚假通过。属统计口径 OBSERVATION，不是测试失败。

**item_36**
- `git diff --exit-code -- inventory.py test_inventory.py TASK_SPEC.md TEST_ONLY_FREEZE.md` 通过；`git status` 仅 `.audit/`、`tests_gate_a/` 未跟踪项。
- 递归清单显示 `tests_gate_a` 仅 4 份文档/代码 + 2 份日志 + `tmp/`（空）；未见 `__pycache__`、`.pytest_cache` 或目录外缓存（另以只读扫描确认全仓库无 `__pycache__`/`.pytest_cache`）。

---

## 4. 交付物与文件增删改

**三份角色交付物 + 自建测试（全部存在，SHA 与 AFTER 一致）**

| 文件 | SHA256 | 内容核验 |
|---|---|---|
| `tests_gate_a/TEST_A_CASES.md` | `4df918b3…c3c32` | A01–A11 场景/预期/风险，覆盖规格与双审边界观察 |
| `tests_gate_a/test_gate_a_inventory.py` | `fbd0abb2…6c3cb` | 12 个 `test_*`；A01–A10 具真实断言；A11 仅记录、无断言（见 O4） |
| `tests_gate_a/TEST_A_EVIDENCE.md` | `23cf1ae6…db5ba` | 命令、退出码、日志、数量与 PASS 表；与原始事件一致 |
| `tests_gate_a/GATE_A_REPORT.md` | `0443dc58…77961` | 固定基线、`GATE_A_PASS`、失败/未验证/范围声明 |

- 报告主张 `12 tests / 12 passed / 0 failures / 0 errors / exit 0`：由 UTF-16 日志与 item_23 `EXIT_CODE=0` 支撑。
- 报告主张 `PRE` 哈希匹配、双审同 Commit/同规格：由独立哈希与 MERGE 支撑。
- 报告未把 `GATE_A_PASS` 写成生产批准；明确为本地 TEST_ONLY。

**BEFORE → AFTER 差异（实测）**
- 新增 6 项，全部位于 `tests_gate_a/`：`GATE_A_REPORT.md`、`TEST_A_CASES.md`、`TEST_A_EVIDENCE.md`、`test_gate_a_inventory.py`、`unittest.log`、`utf8_observation.log`。
- 删除 0、修改 0；META 的 `added_files/removed_files/changed_files` 与此完全一致。
- `.audit` 案卷全部既有文件哈希未变；项目受保护源码/规格未变；`tmp/` 已清空。

**受控配置项（单独记录，不作本轮角色违规）**
- META `protected_changed_basenames=["config.toml"]`，即运行窗口内调度端发现 `<LOCAL_USER_HOME>\.codex\config.toml` 变更（Codex trusted 记录候选）。
- 本次仅记录**现场哈希**（未读取配置内容）：现测 `28ef0965…657944`，与 BASELINE `protected_before` 相同；说明该文件在本次审计时刻已回到基线值，**运行窗口内变更后的字节/差异不在案卷中，无法独立复核**。
- 角色 13 条命令与 2 组 file_change 均未访问该配置路径，无证据显示角色改写；按授权由调度端单独备份、证明差异并处理。此项为 **UNVERIFIED（取证受限）+ OBSERVATION**，不据此判角色 `NON_COMPLIANT`。

---

## 5. 调用参数、代理与模型

- `INVOCATION_ACTUAL.json` 与批准的 `INVOCATION.json`：`argv` 完全相同、`child_env_overrides` 完全相同；且其记录的 `invocation_sha256=0808924b…` 恰等于 `SHA256(INVOCATION.json)`（见下）。
- 实际 argv 显式含 `-ProxyUrl http://127.0.0.1:18888`；子进程变量 `HTTP_PROXY/HTTPS_PROXY/http_proxy/https_proxy` 均同值，`NO_PROXY/no_proxy=127.0.0.1,localhost,::1`；无 `20172`；地址无凭据。
- 角色事件证明：helper 前导行声明 `Role=tester_gate_a`、Soul 路径与哈希；`thread.started` 后实际产生 13 条命令、`turn.completed` —— **已进入角色执行**，说明本次调用获得了模型响应并完成了工作。
- 但：计划/调度记录不等于上游普遍可用；本机端口监听不证明上游可用；`R6` 根因仍为 UNVERIFIED。`PARAMETERS.json` 的 R4/R6/R7 记录层差异已被 PRE/角色正确区分。
- **`observed_model`、服务端模型身份：UNVERIFIED**（仅有 requested `group/gpt-6-luna` 与 argv 参数，无服务端绑定证据）。
- **运行时 Soul 注入：UNVERIFIED**（安装文件哈希与案卷副本一致、helper 前导行声明路径/哈希；但 helper 自述不能独立证明系统提示词实际注入）。

**`error` 事件与 R6 症状**
- 事件 3：`"Reconnecting... 2/5 (workspace routing discovery failed)"`，位于 `turn.started` 之后、任何命令之前；随后角色继续并 `turn.completed`。
- 这是 R6 相同症状字符串的再次出现，但**未导致 `turn.failed`**；未见调度端二次派发证据，角色也未切换模型或自行重试。记为 OBSERVATION，供调用环境诊断；不据此把本轮测试结果判为失败。

---

## 6. 阶段与跨角色合规检查

- **阶段顺序**：Phase 4.5，Tester Gate A 位于 Spec/Quality 独立双审汇合之后；R7 PRE 已 `COMPLIANT` 后才启动唯一一次 Tester；符合授权“先 PRE 后 Tester、各 1 次”的边界。
- **双审合并**：`MERGE.json` 记录 `head=a1d4a57…`、`task_spec_sha256=dafc…`、两份报告哈希均实测一致；Spec/Quality 均为 `APPROVE_WITH_COMMENTS` + PRE/POST `COMPLIANT`；MERGE 明确标注“不同时执行、非生产批准”，角色报告亦未宣称同时审查或生产批准。符合用户“保留 R6 双审、不改判”的要求。
- **R6 历史**：`R6_HISTORY.json` 的 `exit 1 / turn.failed / NOT_RUN / POST NON_COMPLIANT / workspace routing discovery failed` 原判未被本轮覆盖；R6 原始文件哈希与 BASELINE 一致。
- **职责边界**：Tester 仅新增测试与报告，未修改 `inventory.py`、`test_inventory.py`、冻结规格、双审文件、历史审计、Git 元数据；无代码修复、无整改、无部署。
- **预算**：本轮为 Tester PRE 1 次、Tester 角色 1 次、POST 1 次；未见越界重派或模型切换。
- **文件访问边界**：角色只读案卷与规格/实现，只写 `tests_gate_a/`；全部新增与临时夹具均在 `tests_gate_a/` 内，`tmp/` 已清空。

---

## 7. 问题清单与分级

**NON_COMPLIANT：0 项。**

**OBSERVATION（非阻断）**
- O1：`workspace routing discovery failed` 在 turn 开始处再现一次（2/5 重连）后完成；未发生 `turn.failed`，无二次派发。
- O2：item_29 因用 UTF-8 读取 UTF-16 日志而退出 1；属只读核验失败，非 unittest 失败，已由 item_31 正确复核。
- O3：item_31 正则统计 `tests=11`，与 `Ran 12` 存在统计口径差异（换行导致少计），最终报告采用 `Ran 12`，未产生虚假通过。
- O4：A11 `test_invalid_utf8_behavior_is_recorded_as_unspecified_observation` 无断言、恒通过；真实证据来自 item_26 探针，角色已如实标注“observation-only、非 Gate 要求”。
- O5：`ROLE.stderr` 有 3 条 harness 级 MCP 传输错误（`chatgpt.com/backend-api/ps/mcp`），不影响 turn 完成；`TEST_A_EVIDENCE` 的“无网络”应理解为测试/探针范围，非整个 Codex 运行时。
- O6：PRE 的只读范围观察（读自身 `PRE_PROMPT.txt`、列 `.audit`/`tester-a-r6` 名称；无写入、无其他私有内容读取）；PRE 原判保留。
- O7：`config.toml` 运行期受控变更标记，现场哈希已回基线；差异内容不可复核，交调度端按授权处理。

**UNVERIFIED（证据不足，非角色违规）**
- U1：`observed_model`、服务端模型身份。
- U2：运行时 Soul 实际注入。
- U3：子进程代理/临时目录变量的**实际继承**（仅有派发记录，无子进程环境快照）。
- U4：每个 item 的精确时间戳（JSONL 无；仅有 stderr 的 06:55:56–06:56:12Z 窗口与文件 mtime 14:59–15:00 本地时间）。
- U5：`config.toml` 运行窗口内的具体变更字节。
- U6：R6 根因与上游普遍可用性（监听不代表上游、一次成功不证明根因）。
- U7：13 项受控文件中仅 `config.toml` 被 META 标记；其余 12 项与现场逐一哈希一致，但“运行期全量未变”仍以调度端快照为准。

---

## 8. 合规汇总

| 项目 | 数量/状态 |
|---|---|
| 受审角色调用（POST） | 1（`stage21g-r7-tester-a-001`），结论 COMPLIANT |
| PRE 保留 | 1（COMPLIANT，独立原始事件+回执） |
| 命令事件 | 13；12 条退出 0；1 条退出 1（O2，只读核验） |
| 角色交付物 | 3 份文档 + 1 份测试代码 + 2 份原始日志，全部存在且哈希可追溯 |
| 文件增/删/改 | +6 / 0 / 0（全部 `tests_gate_a/`） |
| NON_COMPLIANT | 0 |
| UNVERIFIED | U1–U7（均为已知取证边界） |
| OBSERVATION | O1–O7（均非阻断） |

---

## 9. 对 Gate A 的影响

1. **过程条件已满足**：固定 Commit/规格/Soul/PRE 前提齐备；角色真实启动并完成 13 条命令；真实 `python -m unittest` 运行 12 项、全部 `ok`、`Ran 12/OK`、保存的测试进程退出码 `0`；三份交付物、独立测试代码、UTF-16 原始日志均可核对；未改动业务实现、旧测试、冻结规格、双审与历史材料。
2. **技术结论归属**：`GATE_A_PASS` 是 Tester 在 TEST_ONLY 范围内的技术判定，原证据支持其“12/12 通过”的事实陈述；本审计不代替 Quality/Spec/Arbitrator 重判技术优劣，也不把它升级为生产批准。
3. **仍需并行的外部收口（不影响本角色 POST 合规）**：
   - `config.toml` trusted 记录候选须由调度端单独备份、证明差异并按授权精确清理；若差异包含未知改动，“13 项受控文件未变”这一前提需重新闭环。
   - `workspace routing discovery failed` 原样保留，列入 Codex 调用环境待诊断；本次仅证明该单次调用在重连后跑通。
   - 无效 UTF-8 未捕获回溯作为**非阻断观察**保留，待另行授权的规格/实现决策；不得据此判 Gate A FAIL。
4. **未验证项不得写成已通过**：`observed_model`、服务端身份、运行时 Soul 注入维持 `UNVERIFIED`；本结果为本地 TEST_ONLY，不是生产审批、部署许可或整改/后续 Gate 授权。

---

**POST: COMPLIANT**
