Scope reviewed: fixed commit a1d4a578f9334bfcda8004d25a4a43dfef7ebf13; TASK_SPEC.md SHA256 dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c; TEST_ONLY_FREEZE.md SHA256 bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c

# SPEC_REVIEW_REPORT — STAGE21G-INVENTORY（TEST_ONLY / Phase 3）

## 0. 身份与权限

| 项目 | 值 | 证据/状态 |
|---|---|---|
| task_id | `STAGE21G-INVENTORY` | 派发任务书 |
| phase | Spec Review（Phase 3，TEST_ONLY） | 派发任务书 |
| role_id | `p1-spec-reviewer` | `.audit/spec-r6/SOUL.md:1-11` |
| Soul 版本 | `1.1.0`，Permission-Intent `read_only` | `.audit/spec-r6/SOUL.md:8-11` |
| Soul SHA256 | `5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d` | 实测 `sha256sum .audit/spec-r6/SOUL.md`，与派发值一致 |
| Harness | OpenCode（派发声明） | 派发任务书 |
| requested_model | `magpie/group/deepseek-v4.1-flash` | 派发任务书、`TEST_ONLY_AUTHORIZATION.md:5`、`USER_AUTHORIZATION.md:33-34` |
| observed_model | `UNVERIFIED` | 无独立服务端身份证据；`PRE_RECEIPT.json:12` 亦记录 `UNVERIFIED` |

**权限边界声明**：本次仅为只读静态规格审查。未修改代码、测试、规格、Git 或工作区；未运行项目、测试或探针；未联网、未安装依赖；未访问 `.input/`、原项目、其他 worktree、Quality 私人报告或其他角色私人会话。唯一新建文件为本报告。

## 1. 基线核对

全部哈希为本次实际计算（命令见 §7），不是引用 Worker/Planner 自报。

| 项目 | 期望 | 实际 | 结果 |
|---|---|---|---|
| Git HEAD | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` | 同左（`git rev-parse HEAD`） | VERIFIED |
| TASK_SPEC.md SHA256 | `dafc4a31…8258c` | `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c` | VERIFIED |
| TEST_ONLY_FREEZE.md SHA256 | `bb1fe989…ce63c` | `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c` | VERIFIED |
| inventory.py SHA256 | 与 HEAD/PRE 一致 | `29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4` | VERIFIED |
| test_inventory.py SHA256 | 与 HEAD/PRE 一致 | `fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788` | VERIFIED |
| 受审文件与 HEAD 一致性 | 无工作树改动 | `git diff --quiet -- inventory.py test_inventory.py` exit 0；HEAD blob 分别为 `ff7f749c…`/`1c0c4e55…`，与 `git hash-object` 一致 | VERIFIED |
| 工作树状态 | 仅审计材料未跟踪 | `git status --porcelain` 仅 `?? .audit/` | VERIFIED |
| `.input/`（旧 Planner Soul） | 不得存在 | 不存在（`test -d .input` exit 1，`ls` 无该目录） | VERIFIED |
| `SPEC_REVIEW_REPORT.md` | 审查前不存在 | 不存在（`test -e` exit 1） | VERIFIED |

TASK_SPEC 与 FREEZE 内容与派发 SHA 一致；FILE 哈希变化会按冻结规则停止，本次未发生。

## 2. PRE 证据与调度核对

| 检查项 | 实际证据 | 结果 |
|---|---|---|
| PRE 原始事件哈希 | `.audit/spec-r6/PRE.jsonl` 实测 SHA256 `7fdc2b805c50aa4fbcff5fce0d7d7878ecb84c4c044fe5d3df3f995d07920f74` | VERIFIED |
| 回执记录哈希一致 | `PRE_RECEIPT.json:3-4` 的 `pre_event_sha256` 与实测完全一致 | VERIFIED |
| PRE 退出/结束 | `PRE_RECEIPT.json:5-7`：`pre_exit_code=0`、`pre_finish_reason=stop` | VERIFIED（回执记录层） |
| PRE 判决 | `PRE_RECEIPT.json:8`：`original_verdict=COMPLIANT`；PRE 最终文本（`PRE.jsonl` 第 25 条）结论为 **`PRE: COMPLIANT`** | VERIFIED |
| 调度核对 | `PRE_RECEIPT.json:9`：`dispatcher_check=COMPLIANT`，上游哈希脱敏被记为非阻断观察项并在本机校验 | VERIFIED（回执记录层） |
| 会话一致性 | `PRE_RECEIPT.json:6` 的 `pre_session_id=ses_e50c141f2ffexwn43PCXlyKX96` 与 PRE 全部事件 `sessionID` 一致 | VERIFIED |
| 事件完整性 | PRE 共 26 条事件，含 `step_start`/`tool_use`/`text`/`step_finish`（`reason=stop`），未见中断 | VERIFIED |
| 回执生成时序 | 回执自称 `created_after_pre_and_before_role=true` | UNVERIFIED（无法仅凭文件独立证明写入时序） |

PRE 前置条件满足：PRE 有效 `COMPLIANT`、哈希与回执一致、HEAD/规格/冻结均一致，本角色可开工。未发现需要停止的冲突。

## 3. 逐条规格核查矩阵

判定图例：**VERIFIED** = 以受审 Commit 的代码/测试文本可复核，规格与实现一致；**UNVERIFIED** = 证据不足；**NOT_RUN** = 本角色按授权未执行。本角色不把静态核对写成运行时通过。

### 3.1 用户原始需求（USER_BRIEF / TASK_SPEC §2）

| # | 规格条目 | 实现证据（inventory.py） | 测试证据（test_inventory.py） | 判定 |
|---|---|---|---|---|
| R1 | 每条记录 `sku,delta` 两字段 | `:38-46` 逐行读取并强制 2 字段 | `:87-91` 缺失/多余字段失败 | VERIFIED |
| R2 | `delta` 为整数，可正/负/零 | `:52-61` `int()` 解析，求和保留符号 | `:42-49` `+5`、`-3`、`0` 覆盖 | VERIFIED |
| R3 | 相同 SKU 累计 | `:61` `totals[sku]=totals.get(sku,0)+delta` | `:42-49` 同 SKU 两条相加为 `2` | VERIFIED |
| R4 | 成功结果按 SKU 排序 | `:66` `sorted(totals.items())`（键唯一，等同按 SKU 的 Python 字符串序） | `:33-40` 输入 `beta,alpha`，输出 `alpha,beta` | VERIFIED |
| R5 | 错误列数报错 | `:39-45` 返回 1 并写 stderr | `:87-91` | VERIFIED |
| R6 | 空 SKU 报错 | `:46-51` `if not sku.strip()` 返回 1 | `:96-100`（空、纯空白各一例） | VERIFIED |
| R7 | 非法整数报错 | `:52-60` `ValueError` 返回 1 | `:102-103` | VERIFIED |
| R8 | 无效输入不得产生/展示成功汇总（含先有效后失败） | `:37-64` 全程仅累积；`:66-70` 全部校验通过后才写 stdout | `:93-94`、`:105-108` 断言 `stdout==""` 且退出码非 0 | VERIFIED（静态；运行时 NOT_RUN） |
| R9 | 仅 Python 标准库 | `:7-8` 仅 `csv`、`sys` | `:6-12` 仅标准库 | VERIFIED |
| R10 | 本地运行、不联网/不读生产数据/不调外机/不部署 | 代码无网络、无外部进程、无硬编码生产路径 | 测试仅用 `tempfile` 临时目录（`:15-24`） | VERIFIED（静态） |

### 3.2 冻结接口与边界决策（TEST_ONLY_FREEZE.md）

| # | 冻结条目（来源） | 实现证据 | 测试证据 | 判定 |
|---|---|---|---|---|
| F1 | CLI 接收且仅接收一个本地 CSV 路径参数，输出 CSV 到 stdout（`FREEZE:19`） | `:19-21` 参数数≠1 时 stderr + 退出码 2；`:66-70` 写 stdout | 测试均以 `inventory.main([path],...)` 调用（`:23`）；**参数个数无专门测试** | VERIFIED（实现）；测试缺口见 NIT-1 |
| F2 | 输入 UTF-8、首行表头精确为 `sku,delta`；成功输出同表头（`FREEZE:19`） | `:25` `encoding="utf-8"`；`:10` `HEADER`；`:33-35` 精确比较；`:68` 输出表头 | `:61-65` 成功含表头；`:70-71` 错误表头失败 | VERIFIED |
| F3 | 仅表头 = 有效空汇总（`FREEZE:20`） | `:27-35` 表头通过后无数据行；`:66-71` 仅输出表头，退出 0 | `:61-65` | VERIFIED |
| F4 | 空文件 = 输入错误（`FREEZE:20`） | `:27-32` `header is None` → stderr + 退出 1 | `:67-68` | VERIFIED |
| F5 | 错误表头 = 输入错误（`FREEZE:20`） | `:33-35` | `:70-71` | VERIFIED |
| F6 | 数据中的空行按错误列数处理，不静默忽略（`FREEZE:20`） | `csv.reader` 对空行产生 `[]`，`:39-45` 判为字段数错误 | `:73-74` | VERIFIED |
| F7 | SKU 原样保留为汇总键；空/纯空白 SKU 错误；非空不去首尾空白（`FREEZE:21`） | `:47-51` 判空；`:61` 使用原始 `sku` 作键（不 `strip` 后入键） | `:76-83` 断言 `" alpha "` 原样保留；`:99-100` 纯空白失败 | VERIFIED |
| F8 | `delta` 用标准库整数解析，失败报错（`FREEZE:22`） | `:52-60` | `:102-103` | VERIFIED |
| F9 | 任一错误：非零退出、诊断到 stderr、stdout 无表头/部分汇总/成功标记（`FREEZE:22`） | `:20-21`、`:29-35`、`:40-60`、`:62-64` 全部先 `stderr.write` 后 `return`，stdout 在 `:66` 之后才写 | 失败断言 mixin `:52-57` 同时校验 `code!=0`、`out==""`、`err!=""` | VERIFIED（静态） |
| F10 | 先完整验证/汇总，再输出（`FREEZE:22`） | `:38-64` 校验与累积，`:66-71` 输出 | `:93-94`、`:105-108` | VERIFIED |
| F11 | 成功按 SKU 的 Python 字符串顺序（`FREEZE:19`） | `:66` 字典键排序 | `:33-40` | VERIFIED |
| F12 | 测试用 `python -m unittest` 真实执行；RED 为实际观察（`FREEZE:23`） | 测试文件为标准库 `unittest`（`:9`、`:111-112`） | 真实执行记录不在本次允许读取范围 | 设计 VERIFIED；执行证据 UNVERIFIED |

### 3.3 验收条件（TASK_SPEC §8）

| # | 验收条件 | 证据 | 判定 |
|---|---|---|---|
| A1 | 标准库环境可运行，无第三方运行依赖（`TASK_SPEC:69`） | inventory.py `:7-8`；test_inventory.py `:6-12` | VERIFIED（静态） |
| A2 | 至少两条同 SKU 记录相加，正负覆盖，可验证零值（`:70`） | test `:42-49`：`alpha,5` + `alpha,-3` → `2`；`beta,0` → `0` | VERIFIED（测试设计） |
| A3 | 多 SKU 成功输出按 SKU 排序（`:71`） | test `:33-40` | VERIFIED（测试设计） |
| A4 | 字段缺失/多余、空 SKU、非法整数各有失败测试（`:72`） | test `:87-91`、`:96-100`、`:102-103` | VERIFIED（测试设计） |
| A5 | 有效行后遇错误行无部分汇总/伪成功（`:73`） | test `:93-94`、`:105-108`；实现 `:66` 前不写 stdout | VERIFIED（静态） |
| A6 | 标准库 `unittest` 执行；缺陷存在时失败测试会失败，修复后通过（`:74`） | 测试为 `unittest`；断言对排序/累计/失败输出具突变敏感性（如 `out==""` 可捕获部分输出，`code!=0` 可捕获静默成功） | 设计 VERIFIED；RED/GREEN 实跑 UNVERIFIED |
| A7 | 记录实际测试命令、退出码与固定提交，不得手写 PASS 替代（`:75`） | 仓库存在 `TDD_EVIDENCE.md`（仅目录列表可见），但不在本次允许读取范围；本角色未执行测试 | UNVERIFIED |
| A8 | 无网络、生产数据、外机、部署或第三方依赖（`:76`） | 静态检查代码与测试导入、临时目录 | VERIFIED（静态） |
| A9 | 报告区分 TEST_ONLY 与生产 Gate，后者未批准（`:77`） | `TEST_ONLY_FREEZE.md:4`、本报告 §6 | VERIFIED |

### 3.4 非目标与禁止项（TASK_SPEC §3）

| 条目 | 检查结果 | 判定 |
|---|---|---|
| 不实现生产库存接入、数据库、网络 API、认证、部署、外部集成（`:25`） | 实现仅 CSV 文件读写与内存汇总；无网络/DB/认证/部署代码 | VERIFIED（静态） |
| 不复用/改动 Hermes/P1 生产源码（`:26`） | 当前 worktree 为固定 Commit 的独立实验仓库；受审文件为独立小程序，未引外部模块 | VERIFIED（可见范围内） |
| 不把实验冻结/本地审查说成生产审批（`:27`） | 未见此类声明；本报告亦然 | VERIFIED |
| 不静默跳过坏行、不把非法值当零、失败后不打印部分成功（`:28`） | `:39-60` 三类错误均显式失败；无 `continue`/默认零分支；`:66` 前不输出 | VERIFIED（静态） |

## 4. 问题清单

### BLOCKER
无。未发现实质规格偏离。

### IMPORTANT
无。

### QUESTION（非阻断）

- **Q1 — TASK_SPEC 自身状态文字与冻结记录不一致。**
  - 证据：`TASK_SPEC.md:3` 仍写“状态：候选，未冻结，待调度端依据已批准实验需求核验并记录 TEST_ONLY 冻结”；`TEST_ONLY_FREEZE.md:25` 写“状态：**TEST_ONLY FROZEN**”，且 `:7` 明确以当前 TASK_SPEC SHA 共同冻结。
  - 影响：仅是文档措辞陈旧；冻结记录为调度端权威记录，且 TASK_SPEC 哈希与派发值一致，未造成实现偏离。
  - 建议：由调度端在后续记录中说明“TASK_SPEC 文本状态行为 Planner 原始候选措辞，冻结以 TEST_ONLY_FREEZE.md 为准”，无需改代码。**不影响本次技术判决。**

### NIT

- **NIT-1 — CLI 参数个数无专门测试。**
  - 证据：`inventory.py:19-21` 实现“参数数≠1 报错退出 2”，但 `test_inventory.py` 全部调用均传 `[path]`（`:23`），未覆盖 0 个/多个参数。
  - 影响：不影响 TASK_SPEC §8 任一验收条件；冻结的 CLI 契约实现正确，仅缺少回归保护。
  - 建议：可选的测试增强，不作为阻断项。

### FYI

- **FYI-1 — 非 UTF-8 / CSV 结构异常会以未捕获异常方式失败。**
  - 证据：`inventory.py:62` 仅捕获 `OSError`；`UnicodeDecodeError` 与 `csv.Error` 未捕获，会以 traceback 形式写到 stderr 并以非零退出。因为输出在 `:66` 之后才发生，stdout 仍无部分汇总。
  - 影响：冻结规格只承诺 UTF-8 输入（`FREEZE:19`），且可观察失败契约（非零、stderr、无 stdout）仍满足；属实现健壮性话题，非规格偏离。按职责边界不展开质量/架构审计。
  - 建议：若后续扩展输入范围，再评估统一错误处理。

## 5. 未验证与未执行事项（如实披露）

| 事项 | 状态 | 原因/证据边界 |
|---|---|---|
| 实际运行 `python -m unittest`、测试退出码、RED/GREEN 过程 | **NOT_RUN** | 派发明确要求仅静态审查、不运行测试；本角色未执行任何测试或探针 |
| 验收 A7 的“实际测试命令/退出码/固定提交”证据 | **UNVERIFIED** | `TDD_EVIDENCE.md` 不在本次允许读取清单内；未读取其内容，不引用其结论 |
| Tester Gate A 的执行与结论 | **NOT_RUN / 未发生** | 本角色不代替 Tester Gate A |
| 服务端实际模型身份 `observed_model` | **UNVERIFIED** | 仅有 requested 参数与配置声明；`PRE_RECEIPT.json:12` 同样记录 `UNVERIFIED` |
| 运行时实际加载的系统 Soul | **UNVERIFIED** | 只能核对派发文件与 SHA，无法独立证明运行时加载 |
| 用户授权的消息级 ID/签名/时间戳 | **UNVERIFIED / UNAVAILABLE** | `USER_AUTHORIZATION.md:3` 自述不可用；未凭猜测补造 |
| UPSTREAM 中 `planner-r3` PRE 的 `raw_sha256` 原始事件真实性 | **UNVERIFIED** | `UPSTREAM.json:8` 为占位/脱敏值；原始事件属其他角色私人材料，未重算。摘要级 `COMPLIANT` 与 PRE 回执的非阻断观察一致 |
| PRE 回执“生成于 PRE 之后、角色之前”的时序 | **UNVERIFIED** | 回执自述（`PRE_RECEIPT.json:10`），无法仅凭文件独立证明写入时序 |

以上 UNVERIFIED/NOT_RUN 均未被写成 PASS；其中 A7 属 Tester Gate A 的法定职责，本次不据此阻断静态规格符合性。

## 6. 最终技术判决

**APPROVE_WITH_COMMENTS**

理由：
1. 固定 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` 下，`inventory.py` 与 `test_inventory.py` 完整覆盖 TASK_SPEC §2 的全部明确业务规则、§7 的全部错误条件、§8 的 A1–A6、A8–A9 静态可核部分，以及 TEST_ONLY_FREEZE 的 F1–F11 全部可观察行为；未发现范围扩大、静默跳过坏行、非法值当零、失败后部分输出或未授权架构变化。
2. 评论项仅为：Q1 文档状态措辞、NIT-1 可选测试缺口、FYI-1 非规格范围内的健壮性观察。
3. A7（真实测试命令/退出码/固定提交记录）与运行时 RED/GREEN 仍为 **UNVERIFIED / NOT_RUN**，须由 Tester Gate A 实际执行并留证，不能以本报告替代。

**边界声明**：本判决是 TEST_ONLY 实验内的独立规格审查结论，**不是 Gate A 通过、不是生产 Gate 批准、不是部署许可、不是正式外部物理盲审**。生产 Gate 保持未批准。本次未触发 Remediation、Gate B、Arbitrator，未访问 5bao/9bao/rusty，未联网或部署。

## 7. 工作记录（实际访问与命令）

| 动作 | 对象 | 结果 |
|---|---|---|
| 读取 | `.audit/spec-r6/SOUL.md`（全文 68 行） | Soul 1.1.0 / read_only 与派发一致 |
| 读取 | `.audit/spec-r6/PRE_RECEIPT.json`（13 行）、`.audit/spec-r6/PRE.jsonl`（26 条事件；末条文本结论 `PRE: COMPLIANT`） | 哈希/会话/判决一致 |
| 读取 | `TASK_SPEC.md`（87 行）、`TEST_ONLY_FREEZE.md`（25 行） | 与派发 SHA 一致 |
| 读取 | `USER_BRIEF.md`、`TEST_ONLY_AUTHORIZATION.md`、`.audit/spec-r6/USER_AUTHORIZATION.md`、`.audit/spec-r6/UPSTREAM.json` | 授权与上游摘要已核对 |
| 读取 | `inventory.py`（75 行）、`test_inventory.py`（112 行） | 逐条对照规格 |
| 命令 | `git rev-parse HEAD`；`git status --porcelain` | HEAD 符合；仅 `?? .audit/` |
| 命令 | `sha256sum` 指定文件（SOUL/TASK_SPEC/FREEZE/PRE/代码/文档） | 与派发值及 PRE 记录一致 |
| 命令 | `git ls-tree HEAD -- inventory.py test_inventory.py TASK_SPEC.md TEST_ONLY_FREEZE.md` | blob 已固定 |
| 命令 | `git diff --quiet -- inventory.py test_inventory.py` | exit 0，无改动 |
| 命令 | `git hash-object inventory.py test_inventory.py` | 与 HEAD blob 一致 |
| 命令 | `wc -l .audit/spec-r6/PRE.jsonl` | 26 条事件 |
| 命令 | 只读解析 PRE 第 25 条文本（Python 读取该 JSONL 文件） | 提取结尾 `PRE: COMPLIANT` |
| 命令 | `test -e SPEC_REVIEW_REPORT.md`；`test -d .input` | 均为 exit 1（报告开工前不存在、旧 `.input/` 不存在） |

所有命令均在当前 worktree `[USER_HOME]\Stage21G-R6\spec` 执行，退出码为 0（除两处刻意存在性断言返回 1）。本报告为首行 `Scope reviewed:` 的唯一新建正式文件；未改动任何既有文件。