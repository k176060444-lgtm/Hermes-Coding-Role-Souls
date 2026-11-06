# PRE 审计记录 — `stage21g-r7-tester-a-001`

## 0. 身份、范围与限制

| 项目 | 内容 |
|---|---|
| 审计角色 | 既有 OpenCode `p1-pro-audit`（Soul 1.1.1，read_only） |
| task_id / phase / role_id | `STAGE21G-INVENTORY` / Phase 4.5 / `tester_gate_a` |
| 受审 run_id | `stage21g-r7-tester-a-001` |
| 受审 Harness / requested_model | Codex（既有 `Invoke-P1CodexRole.ps1`）/ `group/gpt-6-luna` |
| observed_model | **UNVERIFIED**（无独立服务端绑定证据） |
| 本次动作 | 仅读取指定案卷、`TASK_SPEC.md`、`TEST_ONLY_FREEZE.md`、必要的只读 Git 信息，以及安装 Soul/helper 的 SHA256；未执行 unittest、未联网、未改文件、未扫描其他 worktree、未递归 grep 全项目 |
| 判决依据 | 字段与 SHA 实测，不以 CLI exit 0 作为判决 |

---

## 1. 基线与文件哈希（实测）

| 文件 | 实测 SHA256 | 与案卷声明 | 判定 |
|---|---|---|---|
| `USER_AUTHORIZATION.md` | `2afbb2afd6758f9656fae1022310d9d051221803c5f2eb05999c4c2b9706f422` | BASELINE 一致 | **VERIFIED** |
| `TASK.md` | `6b083a25ae20482f86455f4537edf0722898622cf42188a2b7e8333b4a6db9a4` | BASELINE 一致 | **VERIFIED** |
| `SOUL.md` | `e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a` | TASK/BASELINE 一致 | **VERIFIED** |
| `MERGE.json` | `4216ed10566b02b52822596437c433f07753913085ce46b877cd601ea3c660fc` | BASELINE 一致 | **VERIFIED** |
| `SPEC_REVIEW_REPORT.md` | `6a0daabd9458b870eb3c58722b6f7e48ccb7ff28f884acd094dd20483a058aa3` | MERGE `spec.report_sha256` 一致 | **VERIFIED** |
| `QUALITY_REVIEW_REPORT.md` | `e26408f0a6a2cb22b9cb71caab812ebc2e784637fa1e5db39d1f0ae9ce81fd7d` | MERGE `quality.report_sha256` 一致 | **VERIFIED** |
| `R6_HISTORY.json` | `6677fed4ffb46edb352238ea4677b45617a1d678784ab5dfe57c1917caca52dd` | BASELINE 一致 | **VERIFIED** |
| `R6_ROLE.stdout` | `5a771bfd8af2404cbb739fbaaaee5ab52457cd19c5f4a5a19405c9f4edb12f9c` | R6_HISTORY `role_stdout_sha256` 一致 | **VERIFIED** |
| `R6_POST.jsonl` | `683abe1e914e5f38b19066687705e895818cae0a85bb95b88f25a4a007786975` | R6_HISTORY `post_event_sha256` 一致 | **VERIFIED** |
| `PARAMETERS.json` | `e53fb891e4fe25b2da4e9906eb64ef204b5959f4e72ae15713771bcba726ad6f` | BASELINE 一致 | **VERIFIED** |
| `INVOCATION.json` | `0808924b905fa1cd89a397395b0fd6b13cc871adc8950a664fd0ce09e219694a` | BASELINE 一致 | **VERIFIED** |
| `BASELINE.json` | `cd2bee0c885539342f0b160724ba55d346bb891da0891fa99e9c37cb9122d1cc` | — | **VERIFIED** |
| `TASK_SPEC.md` | `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c` | TASK/MERGE/FREEZE 一致 | **VERIFIED** |
| `TEST_ONLY_FREEZE.md` | `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c` | TASK/MERGE 一致 | **VERIFIED** |
| 安装 Soul `<LOCAL_USER_HOME>\.codex\p1-roles\tester_gate_a.md` | `e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a` | 与案卷副本同哈希 | **VERIFIED（文件层）** |
| 既有 helper `<LOCAL_USER_HOME>\.codex\p1-roles\Invoke-P1CodexRole.ps1` | `fa7ed710027fbeb3065d7c47550691e27ae9e86726cf8889fd4f209ce400db77` | BASELINE `helper_sha256` 一致 | **VERIFIED** |
| `inventory.py` | `29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4` | SPEC 报告引用一致 | **VERIFIED** |
| `test_inventory.py` | `fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788` | SPEC 报告引用一致 | **VERIFIED** |

---

## 2. 用户新授权与 run_id

| 检查项 | 实测 | 判定 |
|---|---|---|
| 是否为新的 R7 授权、非自动重试 | `USER_AUTHORIZATION.md` 标题为“Stage 21G-R7：Tester Gate A定向恢复”，明确“本次是新的TEST_ONLY授权。不是自动重试” | **VERIFIED** |
| run_id | 授权第 104–105 行建立 `stage21g-r7-tester-a-001`；`TASK.md`、`BASELINE.json`、PRE 派发文本均一致 | **VERIFIED** |
| 本轮调用上限 | 授权第八节：PRE 1 次、Tester 角色 1 次、POST 1 次；不切换模型、不自动重试 | **VERIFIED（授权文本）** |
| 授权范围 | 仅 Tester Gate A；不进入 Remediation/Gate B/Arbitrator/生产流程；不重新运行 Planner/Worker/Spec/Quality | **VERIFIED** |
| 消息级 ID/签名/时间戳 | 授权文件自述“平台未提供可独立验证的消息 ID、签名或时间戳，记为 UNAVAILABLE” | **UNVERIFIED**（内容完整，消息级真实性不可独立证明） |

---

## 3. Tester Soul 正确路径与 SHA

| 检查项 | 实测 | 判定 |
|---|---|---|
| 案卷副本 | `.audit/tester-a-r7/SOUL.md`，SHA `e2530a2b…e98a` | **VERIFIED** |
| 安装路径 | `<LOCAL_USER_HOME>\.codex\p1-roles\tester_gate_a.md`，SHA 同为 `e2530a2b…e98a` | **VERIFIED（文件层）** |
| Soul 身份 | `Soul-Version: 1.1.0`、`Harness: codex`、`Phase: 4.5`、`Permission-Intent: test_files_only`；与 `role_id: tester_gate_a` 匹配 | **VERIFIED** |
| 运行时实际注入 | helper 启动行会自述 Soul 路径/SHA，但该自述不是独立注入证据 | **UNVERIFIED** |
| 路径写法 | TASK 以案卷副本路径指代 Soul，而非安装路径；安装文件哈希已独立核验一致 | **OBSERVATION（非阻断）** |

---

## 4. 固定 HEAD 与两份规格 SHA

| 检查项 | 期望 | 实测 | 判定 |
|---|---|---|---|
| 固定 Commit | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` | `git rev-parse HEAD` 完全一致 | **VERIFIED** |
| `TASK_SPEC.md` | `dafc4a31…8258c` | 实测一致 | **VERIFIED** |
| `TEST_ONLY_FREEZE.md` | `bb1fe989…ce63c` | 实测一致 | **VERIFIED** |
| tracked 工作树 | 无业务代码/规格/测试改动 | `git diff`、`git diff --cached` 为空；`git status --porcelain` 仅 `?? .audit/` | **VERIFIED** |
| 受控文件 | `inventory.py`、`test_inventory.py` 与 SPEC 报告引用哈希一致 | 实测一致 | **VERIFIED** |

---

## 5. 本角色 TASK 与唯一输出目录

| 检查项 | 实测 | 判定 |
|---|---|---|
| TASK 身份字段 | `task_id/run_id/phase/role_id/Harness/requested_model/observed_model/固定 Commit/两份规格 SHA/Soul 路径与 SHA` 均与授权和基线一致 | **VERIFIED** |
| 输出范围 | TASK 第 25–30 行：所有新测试代码、考卷、证据、日志、正式报告及临时夹具仅写入 `./tests_gate_a/` 子树；四类交付物路径明确 | **VERIFIED** |
| 当前输出目录 | `tests_gate_a/` 仅含空 `tmp/`，无测试代码、考卷、日志或报告；`tmp` 为空 | **VERIFIED** |
| 写入限制 | 不得修改 `inventory.py`、现有 `test_inventory.py`、冻结规格、原双审文件、历史审计材料、Git 元数据或其他既有文件；不得安装依赖、联网、访问外机、整改或生产部署 | **VERIFIED** |
| 测试环境 | TASK 要求 `PYTHONDONTWRITEBYTECODE=1`、`PYTEST_ADDOPTS=-p no:cacheprovider`、`TEMP/TMP/TMPDIR` 指向 `tests_gate_a/tmp`；与 `INVOCATION.json` 一致 | **VERIFIED** |
| 测试要求 | 真实运行 Python unittest；覆盖正常汇总、SKU 排序、正负整数、缺/多字段、空 SKU、非法整数、错误输入不产生部分成功；无效 UTF-8 为待验证观察，不预判 BLOCKER；Worker 14 项自测不得冒充 | **VERIFIED** |

---

## 6. 本轮 PRE 原始事件与回执路径

| 检查项 | 实测 | 判定 |
|---|---|---|
| PRE 事件路径 | `TASK.md` 指定 `.audit/tester-a-r7/PRE.jsonl` | **VERIFIED（路径）** |
| PRE 回执路径 | `TASK.md` 指定 `.audit/tester-a-r7/PRE_RECEIPT.json` | **VERIFIED（路径）** |
| 当前存在性 | 两文件当前均不存在；本次 PRE 自身运行时尚未生成，符合用户说明 | **NOT_RUN / 预期缺失，非缺陷** |
| 后续要求 | 调度端须在 PRE 完成后按字节复制并验证，再启动 Tester；TASK 已要求 Tester 开工前核对这两份材料 | **VERIFIED（任务要求）** |

---

## 7. R6 双审案卷核对

| 检查项 | 实测 | 判定 |
|---|---|---|
| MERGE 基线 | `head=a1d4a57…`、`task_spec_sha256=dafc4a…`、`freeze_sha256=bb1fe9…` | **VERIFIED** |
| Spec 报告 | run_id `stage21g-r6-spec-reviewer-001`；verdict `APPROVE_WITH_COMMENTS`；pre/post `COMPLIANT`；报告 SHA `6a0daabd…` 与 MERGE 一致 | **VERIFIED（MERGE/报告副本层）** |
| Quality 报告 | run_id `stage21g-r3-quality-reviewer-001`；verdict `APPROVE_WITH_COMMENTS`；pre/post `COMPLIANT`；报告 SHA `e26408f0…` 与 MERGE 一致 | **VERIFIED（MERGE/报告副本层）** |
| 相同 Commit/规格 | 两份报告均写明 fixed commit `a1d4a57…`、`TASK_SPEC` `dafc4a…`、`FREEZE` `bb1fe9…` | **VERIFIED** |
| Spec PRE 证据 | SPEC 报告引用 PRE 事件 SHA `7fdc2b80…`，与 MERGE `spec.pre_event_sha256` 一致；报告称 PRE 判决 `COMPLIANT` | **VERIFIED（报告引用层）** |
| 双审 PRE/POST 底层事件 | MERGE 记录 spec/quality 的 pre/post 事件 SHA；本次按读取范围未重算 R6 原始事件文件 | **UNVERIFIED（底层事件未重算；不阻断本轮）** |
| 独立性 | MERGE 记录“不同时间对同一 Commit 独立审查，不宣称同时运行或生产批准”；报告内容与授权一致 | **VERIFIED（记录层）** |
| 生产属性 | MERGE 与报告均声明 TEST_ONLY，非生产批准 | **VERIFIED** |

说明：Quality 报告 run_id 为 R4 的 `stage21g-r3-quality-reviewer-001`，由 R6 MERGE 汇合；两份报告均对应同一固定 Commit/规格，符合授权“同一固定Commit和TASK_SPEC”的要求，不构成缺陷。

---

## 8. R6 失败原判保留

| 检查项 | 实测 | 判定 |
|---|---|---|
| `exit 1` | `R6_HISTORY.json` `R6_role_exit: 1`；R6 POST 报告引用 `role.exit=1` | **VERIFIED** |
| `turn.failed` | `R6_ROLE.stdout` 第 15 行 `{"type":"turn.failed",...}`；`R6_HISTORY` `turn_failed: true` | **VERIFIED** |
| 测试 `NOT_RUN` | `R6_HISTORY` `tester_commands: 0`、`test_status: NOT_RUN`；R6 POST 报告确认无任何 command/exec item | **VERIFIED** |
| POST `NON_COMPLIANT` | `R6_HISTORY` `post_verdict: NON_COMPLIANT`；`R6_POST.jsonl` 末条文本明确 `POST: NON_COMPLIANT` | **VERIFIED** |
| 调用谱系 | thread `01a1af54-83c2-72b0-bf39-4beba341e328` 在 `R6_HISTORY` 与 `R6_ROLE.stdout` 一致 | **VERIFIED** |
| 历史未被覆盖 | R6_HISTORY 明确“历史失败不被覆盖”；R7 案卷保留 R6_ROLE.stdout / R6_POST.jsonl 原哈希 | **VERIFIED** |

---

## 9. 参数证据与代理计划

| 证据层 | 实测 | 判定 |
|---|---|---|
| R4 成功调用 | `ProxyUrl=http://127.0.0.1:18888`；`inherited_before_helper=UNVERIFIED`；`lowercase_inherited=UNVERIFIED` | **VERIFIED（记录层）** |
| R6 失败调用 | `ProxyUrl=NOT_SUPPLIED`；父进程观测 `HTTP_PROXY/HTTPS_PROXY=127.0.0.1:20172`；未保存独立子进程环境快照 | **VERIFIED（记录层）** |
| 本轮调用计划 | `ProxyUrl=http://127.0.0.1:18888`；四个 HTTP/HTTPS 大小写变量显式同值 | **VERIFIED（计划层）** |
| 显式 `-ProxyUrl` | `INVOCATION.json` argv 含 `-ProxyUrl http://127.0.0.1:18888` | **VERIFIED（计划层）** |
| 子进程代理变量 | `HTTP_PROXY`、`HTTPS_PROXY`、`http_proxy`、`https_proxy` 均为 `http://127.0.0.1:18888` | **VERIFIED（计划层）** |
| 20172 继承 | R7 计划中无 20172；20172 仅出现在 R6 历史记录与授权禁止项 | **VERIFIED（计划层）** |
| 代理凭据 | `proxy_has_credentials=false`；计划地址为无凭据 loopback | **VERIFIED** |
| 监听检查 | BASELINE 记录 `TCP 0.0.0.0:18888 ... LISTENING 7616`；`listener_does_not_prove_upstream=true` | **VERIFIED（记录层）；上游可用性 UNVERIFIED** |
| R6 根因 | `r6_root_cause=UNVERIFIED`；未将代理差异定为已证实根因 | **VERIFIED（未过度归因）** |
| `NO_PROXY` 附加项 | 计划额外设置 `NO_PROXY/no_proxy=127.0.0.1,localhost,::1`；不影响对 `chatgpt.com` 的上游代理，且无凭据 | **OBSERVATION（非阻断）** |
| CodexExe | 计划为 `D:/codex/codex-agent.exe`；R4/R6 参数记录未逐项记录该路径，无法独立比较版本 | **UNVERIFIED（版本/历史对比）** |
| helper 实际覆盖行为 | BASELINE 记录 helper 接受 `-ProxyUrl` 并覆盖大写代理；本次未执行 helper | **UNVERIFIED（实际运行前）；计划层已显式设置四变量** |

---

## 10. BASELINE 记录核对

| 检查项 | 实测/记录 | 判定 |
|---|---|---|
| 全部声明哈希 | 本次独立重算的 TASK、授权、Soul、MERGE、PARAMETERS、INVOCATION、HISTORY、PRE_PROMPT、helper 均与 BASELINE 一致 | **VERIFIED** |
| `run_id` 未使用 | BASELINE `run_id_search`：opencode_db E=0/C=0，codex 68 sessions 无匹配；案卷无本轮 PRE 文件 | **VERIFIED（记录层 + 目录层）** |
| `tests_gate_a` 空 | 仅空 `tmp/` | **VERIFIED** |
| `records_dir_absent` | PRE.jsonl/PRE_RECEIPT.json 当前不存在 | **VERIFIED（预期）** |
| `protected_13` | BASELINE 记录 13 项受控文件及哈希；本次独立重算 Soul 与 helper，其余 11 项未逐项重算 | **VERIFIED（记录层）；其余 UNVERIFIED** |
| `r6_archive_verified=74` | BASELINE 记录；本次未重读 R6 归档 | **VERIFIED（记录层）** |
| `observed_model` | `UNVERIFIED` | **VERIFIED（未冒充）** |

---

## 11. UNVERIFIED / OBSERVATION 汇总（均不构成本轮阻断）

**UNVERIFIED**
1. 服务端 `observed_model`：仅有 requested `group/gpt-6-luna`，无独立服务端绑定证据。
2. 系统 Soul 实际注入：安装文件哈希与案卷副本一致，但 helper 自述不等于独立注入证明。
3. 用户授权消息级 ID/签名/时间戳：授权文件自述 UNAVAILABLE。
4. R6 双审底层 PRE/POST 事件哈希：MERGE 记录存在且报告副本哈希一致，但 R6 原始事件文件不在本轮允许读取范围，未重算。
5. helper 实际参数覆盖行为：计划已显式设置四变量，但未在 PRE 阶段执行 helper。
6. 13 项受控文件全量哈希：仅独立重算 Soul/helper，其余为 BASELINE 记录层。
7. R6 归档 74 项：BASELINE 记录层，未重读。
8. 监听端口上游可用性：仅有本机 LISTENING，不能证明上游可用。
9. CodexExe 版本/历史对比：R4/R6 参数记录未逐项记录该路径。

**OBSERVATION**
1. TASK 以案卷副本路径指代 Soul，安装路径哈希已独立核验一致。
2. `INVOCATION.json` 额外设置 `NO_PROXY/no_proxy` 为 loopback；不影响上游代理，无凭据。
3. Quality 报告 run_id 为 R4 的 `stage21g-r3-quality-reviewer-001`，由 R6 MERGE 汇合；同一 Commit/规格，符合授权。
4. R6 报告 Commit `59297584…` 不在本实验仓库对象库中；授权将其与实验代码 Commit `a1d4a57…` 区分，本轮 Tester 固定后者，不影响 PRE。

---

## 12. 结论

本轮 R7 PRE 的关键开工条件均已满足：

- 新 R7 授权、run_id、Tester Soul 路径/SHA、固定 HEAD、两份规格 SHA 全部一致；
- TASK 的身份、模型、输出目录、测试要求、写入限制与授权一致；
- R6 双审案卷的报告哈希、相同 Commit/规格、PRE/POST 记录在 MERGE 层一致；
- R6 的 `exit 1`、`turn.failed`、测试 `NOT_RUN`、POST `NON_COMPLIANT` 原判完整保留；
- 参数证据明确区分 R4 成功、R6 失败、R7 计划与历史未记录环境；
- R7 计划显式 `-ProxyUrl http://127.0.0.1:18888`，四个代理变量均指向该值，无 20172 继承，无代理凭据；
- BASELINE 仅记录监听，不推断上游可用；R6 根因保持 `UNVERIFIED`；
- `observed_model`、运行时 Soul 注入、消息级签名/ID 等按用户要求标为 `UNVERIFIED`，未凭空增加生产审批。

未发现 `NON_COMPLIANT` 级别缺陷；上述 `UNVERIFIED`/`OBSERVATION` 项均为已知范围限制或非阻断记录项。调度端须在 PRE 完成后按字节复制并验证 `.audit/tester-a-r7/PRE.jsonl` 与 `PRE_RECEIPT.json`，再启动唯一一次 Tester。

**PRE: COMPLIANT**
