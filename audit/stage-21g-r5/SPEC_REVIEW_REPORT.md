Scope reviewed: 仓库 `stage21g-inventory-20261106/project`，固定受审 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`；冻结规格 `TASK_SPEC.md`（SHA256 `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`）与 `TEST_ONLY_FREEZE.md`（SHA256 `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`）；仅静态只读审查，未运行被审程序、测试或功能探针。

# SPEC_REVIEW_REPORT — Inventory CSV CLI（TEST_ONLY）

## 1. 身份与基线

| 项 | 值 | 证据/状态 |
|---|---|---|
| task_id | `STAGE21G-INVENTORY` | 派发任务 `.audit/spec-r5/TASK.md:5` — VERIFIED |
| run_id | `stage21g-r5-spec-reviewer-001` | `.audit/spec-r5/TASK.md:6` — VERIFIED |
| phase / role_id | `3` / `p1-spec-reviewer` | `.audit/spec-r5/TASK.md:7-8` — VERIFIED |
| Soul 版本 / Harness | `1.1.0` / OpenCode | `.audit/spec-r5/SOUL.md:8-9` — 文件为 Spec Reviewer Soul，非旧 Planner Soul |
| Soul SHA256 | `5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d` | 实测 `.audit/spec-r5/SOUL.md` 一致 — VERIFIED（仅证明副本哈希，不证明运行时加载） |
| requested_model | `magpie/group/deepseek-v4.1-flash` | `.audit/spec-r5/TASK.md:10` |
| observed_model | `UNVERIFIED` | 无服务端绑定证据；`.audit/spec-r5/BASELINE.json:5` 亦为 UNVERIFIED |
| 受审 Commit | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` | `git rev-parse HEAD` 返回同值 — VERIFIED |
| 父提交 | `f2fafe432e0102d0249bfa2d6827a5f7c84a449e` | 初始仅含 `USER_BRIEF.md`、`TEST_ONLY_AUTHORIZATION.md` — VERIFIED |
| TASK_SPEC SHA256 | `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c` | 实测一致 — VERIFIED |
| FREEZE SHA256 | `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c` | 实测一致 — VERIFIED |
| 权限意图 | read_only | `.audit/spec-r5/SOUL.md:11` |

## 2. 工作记录与证据边界

实际执行的只读命令（均在仓库根目录）：

| 命令 | 结果 |
|---|---|
| `sha256sum .audit/spec-r5/SOUL.md TASK_SPEC.md TEST_ONLY_FREEZE.md` | 三项均与派发值逐字节一致 |
| `sha256sum inventory.py test_inventory.py TDD_EVIDENCE.md WORKER_REPORT.md` | 与 `BASELINE.json:10-17` 记录一致 |
| `git rev-parse HEAD` | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` |
| `git status --porcelain` | 已跟踪文件无修改；仅未跟踪 `.audit/`、`.input/`、`QUALITY_REVIEW_REPORT.md`、`WORKER_REPORT.md` |
| `git show --stat a1d4a57` | 8 files changed, 721 insertions(+) |
| `git diff --stat a1d4a57 -- inventory.py test_inventory.py TASK_SPEC.md TEST_ONLY_FREEZE.md` | 空输出，EXIT=0 → 工作树与受审 Commit 一致 |
| `git diff --stat f2fafe4 a1d4a57 -- USER_BRIEF.md TEST_ONLY_AUTHORIZATION.md` | 空输出，EXIT=0 → 用户需求与授权文件未被改动 |
| `grep -rIn stage21g-r5-spec-reviewer-001 --exclude-dir=.git .` | 仅命中派发材料（TASK/PRE_PROMPT/BASELINE/USER_AUTHORIZATION），无角色运行记录 |
| `git ls-tree -r --name-only f2fafe4` | 仅 `TEST_ONLY_AUTHORIZATION.md`、`USER_BRIEF.md` |

有意未做：未读取 `QUALITY_REVIEW_REPORT.md` 及其私人材料；未读取 `TDD_EVIDENCE.md`（不在本次允许材料清单内）；未运行 `python`、未执行 unittest、未做任何功能探针、未联网、未修改既有文件或 Git 元数据。本报告不构成生产批准、外部盲审或“测试已通过”的证明。

## 3. 开工前置核验（PRE / 调用预算）

- 路径、Soul 哈希、TASK_SPEC 哈希、FREEZE 哈希、HEAD、工作目录均符合派发要求（见第 1、2 节）。
- 调用预算：`run_id` 在仓库内仅出现于 `.audit/spec-r5/` 的派发材料（TASK、PRE_PROMPT、BASELINE、USER_AUTHORIZATION），未发现该 run_id 的 `pre.jsonl`、`role.jsonl` 或 POST 记录；在本次限定扫描范围内，不存在此前同类调用证据。该结论仅限本仓库可读文件，不是全局绝对证明。
- **PRE 判决证据缺口（QUESTION / UNVERIFIED）**：`.audit/spec-r5/` 中不存在 `PRE: COMPLIANT` 的独立判决记录。`BASELINE.json:52-81` 的 `checks` 全为 `true`，但它是开工条件布尔核验，不含 `PRE: COMPLIANT / NON_COMPLIANT / UNVERIFIED` 最终判决字段；`PRE_PROMPT.txt:9` 明确要求该判决，且 PRE 被要求只读、不应写文件。因此“角色只在 PRE 有效通过后启动”目前只能依据调度端自述，仓库内不可独立复核。详见 SR-01。

## 4. 逐条规格核对矩阵

状态说明：`已满足(静态)` = 依据代码与测试源码静态核对一致；`缺执行证据` = 代码/测试存在但运行结果未经本角色执行验证。

### 4.1 已批准需求（TASK_SPEC 第 2 节 / USER_BRIEF）

| # | 规格条目（文件:行） | 实现/测试证据 | 状态 |
|---|---|---|---|
| R1 | 每条记录 `sku,delta` 两字段 — `TASK_SPEC.md:12` | `inventory.py:10` HEADER；`:39-46` 行解析；`test_inventory.py:34-40` | 已满足(静态) |
| R2 | delta 为整数，可正/负/零 — `TASK_SPEC.md:13` | `inventory.py:52-61`；`test_inventory.py:42-49`（+5、-3、0） | 已满足(静态) |
| R3 | 相同 SKU 累计 — `TASK_SPEC.md:14` | `inventory.py:61` `totals[sku] = totals.get(sku,0)+delta`；`test_inventory.py:42-49` | 已满足(静态) |
| R4 | 成功结果按 SKU 排序 — `TASK_SPEC.md:15,56` | `inventory.py:66` `sorted(totals.items())`；`test_inventory.py:33-40` | 已满足(静态) |
| R5 | 字段数错误、空 SKU、非法整数必须报错 — `TASK_SPEC.md:16,61-63` | `inventory.py:39-60`；`test_inventory.py:87-103` | 已满足(静态) |
| R6 | 无效输入不得产生/展示成功汇总（含部分有效后失败）— `TASK_SPEC.md:17,64` | `inventory.py:37-71`：全部校验通过后才在 `:66-70` 写 stdout；`test_inventory.py:93-108` | 已满足(静态) |
| R7 | 仅 Python 标准库，无第三方依赖 — `TASK_SPEC.md:18` | `inventory.py:7-8` 仅 `csv`,`sys`；`test_inventory.py:6-10` 仅标准库 | 已满足(静态) |
| R8 | 本地运行，不联网/不读生产数据/不调外机 — `TASK_SPEC.md:19` | 两文件无网络/外部进程调用；测试仅用 `tempfile` (`test_inventory.py:17-24`) | 已满足(静态) |
| R9 | 使用指定实验仓库，不用 Hermes/P1 源码 — `TASK_SPEC.md:20` | 提交仅含本项目文件；`git ls-tree` 无外部源码 | 已满足(静态) |
| R10 | 仅存在可复现缺陷才触发整改 — `TASK_SPEC.md:21` | 本 Commit 无整改动作 | 不适用（无整改发生） |

非目标（`TASK_SPEC.md:23-28`）：未发现数据库、网络 API、认证、部署、外部集成或生产源码引用；`inventory.py:1-75` 无相关导入。— 已满足(静态)。

### 4.2 冻结记录决策（TEST_ONLY_FREEZE 第 2 节）

| # | 冻结条目（文件:行） | 实现/测试证据 | 状态 |
|---|---|---|---|
| F1 | 单个本地 CSV 路径参数；UTF-8；首行表头 `sku,delta`；成功输出同表头并按 SKU 排序 — `TEST_ONLY_FREEZE.md:19` | `inventory.py:19-35,66-70`；`test_inventory.py:33-40` | 已满足(静态) |
| F2 | 仅表头 = 合法空汇总；空文件/错误表头 = 错误；数据空行按错误列数处理 — `TEST_ONLY_FREEZE.md:20` | `inventory.py:27-35,38-45`；测试 `test_inventory.py:61-74` | 已满足(静态) |
| F3 | SKU 原样保留；空/纯空白 SKU 报错；非空不去首尾空白 — `TEST_ONLY_FREEZE.md:21` | `inventory.py:47,61`（仅 `strip()` 判空，键用原值）；测试 `test_inventory.py:76-83,96-100` | 已满足(静态) |
| F4 | Python 标准库整数解析；任一错误非零退出、诊断入 stderr、stdout 无表头/部分汇总；先校验汇总再输出 — `TEST_ONLY_FREEZE.md:22` | `inventory.py:52-60`、`:62-64`、`:66-71`；测试 `test_inventory.py:52-57` | 已满足(静态) |
| F5 | 仅标准库、不联网；用 `python -m unittest` — `TEST_ONLY_FREEZE.md:23` | `inventory.py:7-8`；`test_inventory.py:111-112` | 代码满足(静态)；实际执行 UNVERIFIED |

### 4.3 验收条件（TASK_SPEC 第 8 节）

| # | 验收条目（`TASK_SPEC.md:67-77`） | 证据 | 状态 |
|---|---|---|---|
| A1 | 标准库可运行、无第三方运行依赖 | `inventory.py:7-8`；`test_inventory.py:6-10` | 已满足(静态) |
| A2 | ≥2 条同 SKU 记录相加，正负与零值 | `test_inventory.py:42-49` | 已满足(静态) |
| A3 | 多 SKU 按 SKU 排序 | `test_inventory.py:33-40` | 已满足(静态) |
| A4 | 缺/多字段、空 SKU、非法整数各有失败测试 | `test_inventory.py:87-103` | 已满足(静态) |
| A5 | 有效行后遇错误行无部分汇总/伪成功 | `test_inventory.py:93-108`；`inventory.py:37-71` | 已满足(静态) |
| A6 | unittest 执行；缺陷存在时失败、修复后通过 | 测试源码存在，但本角色未运行；`WORKER_REPORT.md:42-49,102-114` 为角色自述 | 缺执行证据（UNVERIFIED） |
| A7 | 记录实际测试命令、退出码与固定提交 | `WORKER_REPORT.md:76-114,148-156` 记录命令/`EXIT_CODE=0`/提交；属交接自述 | 缺独立证据（UNVERIFIED） |
| A8 | 无网络、生产数据、外机、部署或第三方依赖 | 静态导入与调用面核对 | 已满足(静态) |
| A9 | 报告区分 TEST_ONLY 与生产 Gate（后者未批准） | `WORKER_REPORT.md:179`；`TEST_ONLY_FREEZE.md:4`；`TASK_SPEC.md:4` | 已满足(静态) |

### 4.4 范围与变更面

- 受审 Commit 变更 8 个文件：2 个实现/测试（`inventory.py`、`test_inventory.py`）、5 个既有冻结/规划输入首次纳入提交、1 个 `TDD_EVIDENCE.md`（未读取）。
- 未发现新增业务模块、依赖、网络代码或超出规格的功能；未发现对 `USER_BRIEF.md`、`TEST_ONLY_AUTHORIZATION.md` 的改动。
- 结论：无范围扩大、无未授权架构变化。

## 5. 问题清单

| ID | 分级 | 位置 | 证据与复现路径 | 实质影响 | 最小纠正建议 |
|---|---|---|---|---|---|
| SR-01 | **QUESTION / UNVERIFIED**（流程证据，非代码缺陷） | `.audit/spec-r5/`（无 `pre.jsonl`/`role.jsonl`/判决文件）；`BASELINE.json:52-81`；`PRE_PROMPT.txt:9` | 按派发要求复核 `PRE: COMPLIANT`：目录仅有 BASELINE/PRE_PROMPT/SOUL/TASK/USER_AUTHORIZATION；`BASELINE.checks` 为布尔项，不含最终判决。 | 无法独立确认“PRE 有效通过”这一启动门禁；本报告不能替代或补写 PRE 判决。 | 由调度端留存本次 PRE 的原始事件与最终判决（或明确声明判决位于何处），供 POST 汇合复核。 |
| SR-02 | **UNVERIFIED**（验收 A6/A7） | `test_inventory.py:1-112`；`WORKER_REPORT.md:76-114,168-172` | 本角色仅做静态审查，未运行 `python -m unittest`；测试通过、RED/GREEN 记录只来自 Worker 自述与未授权的 `TDD_EVIDENCE.md`。 | 无法把“14 项测试实际通过、退出码 0”认定为已独立验证；不影响静态规格符合性判断。 | 由独立 Tester Gate A 在固定 Commit 上实际运行并留存命令/退出码。 |
| SR-03 | **UNVERIFIED**（身份） | `.audit/spec-r5/TASK.md:10-11`；`BASELINE.json:5` | 无服务端模型绑定证据；`.audit/spec-r5/SOUL.md` 仅证明副本哈希。 | 无法证明实际执行模型或运行时 Soul 加载。 | 需要可独立核验的服务端/运行日志证据；本报告不冒充。 |
| SR-04 | **NIT**（文档一致性） | `TASK_SPEC.md:3`；`TEST_ONLY_FREEZE.md:25` | TASK_SPEC 自称“候选，未冻结”，冻结记录却声明 `TEST_ONLY FROZEN` 并绑定同哈希。 | 无功能影响；冻结权威性由 `TEST_ONLY_FREEZE.md:25` 与哈希绑定解决。 | 无需改冻结文件；后续如重开规格再统一措辞。 |
| SR-05 | **OPTIONAL / FYI**（规格未规定） | `inventory.py:24-25,62-64` | 静态推断：NUL 字符或非 UTF-8 输入可能触发未捕获的 `csv.Error`/`UnicodeDecodeError`，以 traceback 形式落到 stderr。 | 仍为非零退出且 stdout 为空，未违反冻结的失败语义；冻结规格未定义编码/CSV 解析异常文案。 | 如要求受控诊断，可显式捕获 `csv.Error`/`UnicodeError`；非本次验收必需，不阻断。 |
| SR-06 | **FYI**（行为提示） | `inventory.py:53`；`TEST_ONLY_FREEZE.md:22` | `int()` 会接受 `+5`、`" 5 "`、`1_000` 等 Python 可解析形式。 | 冻结记录明确“使用 Python 标准库整数解析”，故不构成偏离；Tester 若按“仅十进制字面量”假设需注意。 | 无需修改；测试边界时按冻结口径理解。 |
| SR-07 | **FYI**（授权证据口径） | `.audit/spec-r5/USER_AUTHORIZATION.md:3,95`；`TEST_ONLY_AUTHORIZATION.md:7` | 授权节选明确无消息 ID/签名，属不可独立认证的文本节选。 | 不证明用户身份，但不构成本次代码规格偏离；不得写成已认证批准。 | 按 TEST_ONLY 口径披露，不升级为生产批准。 |
| SR-08 | **FYI**（格式） | `WORKER_REPORT.md:145` | 冻结/规划文档存在既有行尾空格，`git diff --check` 报 2 处。 | 不影响功能；修改会破坏冻结哈希。 | 保持原样，非阻断。 |

未发现 **BLOCKER** 或 **IMPORTANT** 级别的规格偏离：没有发现范围扩大、行为缺失、边界规则被静默改写、用户策略误解或未授权架构变化。

## 6. 逐条结论摘要

- 冻结规格的输入契约、汇总规则、错误语义、排序规则、原子失败（无部分输出）、标准库与本地范围，均能在 `inventory.py:19-71` 与 `test_inventory.py` 中找到一致实现与对应测试。
- 冻结记录对 5 个未定边界（接口、空汇总、SKU 空白、错误流/退出码、先校验后输出）的决策，实现逐项对齐（见 4.2）。
- 唯一实质缺口是**证据层面**：PRE 判决不可复核（SR-01）、测试执行结果与 RED/GREEN 未由本角色独立验证（SR-02）、模型身份不可验证（SR-03）。这些不是代码规格偏离。

## 7. 最终判决

**APPROVE_WITH_COMMENTS**

- 就**冻结 TASK_SPEC / TEST_ONLY_FREEZE 的规格符合性**而言，受审 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` 的候选实现静态核对全部满足，无实质规格偏离。
- 该判决**不是**对 PRE 门禁、测试已运行、模型身份或生产 Gate 的认证；SR-01/SR-02/SR-03 仍为 `QUESTION`/`UNVERIFIED`。
- 若汇合规则要求必须存在可复核的 `PRE: COMPLIANT` 原始判决才能采纳本报告，请按 SR-01 的 QUESTION 处理，不得以本报告替代 PRE 结论。

## 8. 不确定性与限制

1. `PRE: COMPLIANT` 的独立证据在仓库内缺失（SR-01）；调度端自述不作为已验证事实。
2. 本角色为静态审查，未执行任何测试或程序；`UNVERIFIED` 与 `NOT_RUN` 均未被写成 PASS。
3. 未读取 `QUALITY_REVIEW_REPORT.md`、Quality 私人输入、`TDD_EVIDENCE.md` 或角色会话，故不对其内容作任何判断。
4. `observed_model` 与运行时 Soul 加载无独立证据。
5. 调用预算核查仅覆盖仓库内可读材料；不构成对全局历史或其他项目的绝对证明。
6. 本报告不构成生产 P1 批准、部署授权或正式外部盲审；生产 Gate 仍为 `NOT_APPROVED`。