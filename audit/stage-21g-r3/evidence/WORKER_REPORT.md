# Worker 报告 — Inventory CSV CLI（TEST_ONLY）

## 身份与基线

- task_id：`STAGE21G-INVENTORY`
- run_id：`stage21g-r3-worker-001`
- phase / role：`2` / `p1-worker`
- Harness：OpenCode
- requested_model：`magpie/group/deepseek-v4.1-flash`
- observed_model：`UNVERIFIED`。没有服务端模型绑定证据，本报告不把请求模型当作实际执行身份。
- worker Soul SHA256：`8c946fadc63de290dac99571951661f3aeb9223d1cdba1a2c6d37e5383d659b8`（实测 `.audit/worker-r3/SOUL.md` 与派发值一致）
- 基线 Git HEAD：`f2fafe432e0102d0249bfa2d6827a5f7c84a449e`（开工时 `git rev-parse HEAD` 一致）
- 本次产出 Commit：`a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`（短 SHA `a1d4a57`）
- 父提交：`f2fafe432e0102d0249bfa2d6827a5f7c84a449e`
- TASK_SPEC.md SHA256：`dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`
- TEST_ONLY_FREEZE.md SHA256：`bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`
- USER_ALIGNMENT.md SHA256：`3091b5b4917f63d2a6d474cad3ce4b927deb15ebf4579bc9e9536c038acd3d6d`
- TDD_TASKS.md SHA256：`b687d33b7fec780bad29adc793191c9c8d7149318e1fab05d84415a88a49ab16`
- PLANNER_REPORT.md SHA256：`cac988e7d060047c86a5b7e89ac978dbe73f30a72538a6854eb3ce629a12d48a`

上述 TASK_SPEC 与 TEST_ONLY_FREEZE 哈希和冻结记录一致；提交前后 `TASK_SPEC.md`、`TEST_ONLY_FREEZE.md` 均未改动。

## 已读取的输入

- `USER_BRIEF.md`
- `TASK_SPEC.md`
- `TEST_ONLY_FREEZE.md`
- `TDD_TASKS.md`
- `USER_ALIGNMENT.md`
- `PLANNER_REPORT.md`
- `.audit/planner-r3/USER_AUTHORIZATION.md`
- `.audit/worker-r3/TASK.md`
- `.audit/worker-r3/BASELINE.json`
- `.audit/worker-r3/SOUL.md`

缺项：无阻断性缺项。授权副本仍不具备服务端签名或消息级 ID（授权文件自身已说明），本报告不将其表述为独立身份认证。

## 本次工作记录

按 `TDD_TASKS.md` 顺序执行真实 TDD：

1. 任务 1：先添加有效汇总与排序测试，因 `inventory.py` 不存在观察到 ImportError RED；最小实现后 GREEN。
2. 任务 2：添加同 SKU 正负累计与零值测试，观察到同 SKU 被覆盖为 `-3` 的 RED；实现累加后 GREEN。
3. 任务 3：添加缺字段、多字段及有效前缀后坏字段数测试，观察到未受控 `ValueError` RED；实现字段数校验后 GREEN。
4. 任务 4：添加空 SKU 与纯空白 SKU 测试，观察到错误输入返回 `0` 并输出成功汇总的 RED；实现 `sku.strip()` 判空后 GREEN。
5. 任务 5：添加非法整数测试，观察到 `int('abc')` ValueError RED；实现受控解析后 GREEN。
6. 任务 6：添加“有效行后接非法整数”端到端原子性测试；该测试首次运行即通过，**未观察到 RED**，原因是从任务 1 起就采用全部成功后统一输出，不存在自然的部分输出路径。未故意植入缺陷。
7. 任务 7：添加冻结边界测试。空文件测试观察到 StopIteration RED 并已修复；仅表头、错误表头、数据空行、非空 SKU 空白保留四项首次运行即符合冻结决策，**没有各自的 RED 记录**，已如实标记。
8. 任务 8：整理重复失败断言辅助方法为 `FailureAssertionsMixin`，断言强度不变；完整标准库测试通过。

未执行：联网、安装依赖、外机调用、生产数据读取、配置修改、部署、推送、其他角色调度。

## 涉及文件

新增并提交：

- `inventory.py`（75 行，CLI 与校验/汇总实现）
- `test_inventory.py`（112 行，14 个标准库 unittest）
- `TDD_EVIDENCE.md`（RED/GREEN/REFACTOR 实际证据）

随本次实验 Commit 首次纳入工作树文件（内容未修改）：

- `USER_ALIGNMENT.md`
- `TASK_SPEC.md`
- `TDD_TASKS.md`
- `PLANNER_REPORT.md`
- `TEST_ONLY_FREEZE.md`

未提交、保持未跟踪：

- `.audit/`
- `.input/`

## 测试与构建证据

标准测试命令（工作目录为实验仓库根目录，Python 3.11.15）：

```text
PYTHONDONTWRITEBYTECODE=1 python -m unittest -v test_inventory
```

测试实现并提交后的实际结果：

```text
test_blank_line_fails_without_success_output ... ok
test_empty_file_fails_without_success_output ... ok
test_header_only_is_valid_empty_summary ... ok
test_non_empty_sku_whitespace_is_preserved ... ok
test_wrong_header_fails_without_success_output ... ok
test_empty_sku_fails_without_success_output ... ok
test_extra_field_fails_without_success_output ... ok
test_failure_after_valid_rows_exposes_no_partial_summary ... ok
test_missing_field_fails_without_success_output ... ok
test_non_integer_delta_fails_without_success_output ... ok
test_valid_prefix_then_bad_field_count_has_no_partial_output ... ok
test_whitespace_only_sku_fails_without_success_output ... ok
test_same_sku_accumulates_positive_negative_and_zero ... ok
test_valid_input_summarizes_and_sorts_by_sku ... ok

Ran 14 tests in 0.033s

OK
EXIT_CODE=0
```

另以派发要求的标准发现方式执行：

```text
PYTHONDONTWRITEBYTECODE=1 python -m unittest
..............
Ran 14 tests in 0.033s
OK
EXIT_CODE=0
```

每个原子任务的 RED/GREEN 原始输出摘录见 `TDD_EVIDENCE.md`。运行后未生成 `__pycache__` 或 `*.pyc`。

## 提交与 Diff

- 提交前已执行 `git add` 仅限授权清单文件，`git status --short` 显示 `.audit/`、`.input/` 仍为未跟踪且未暂存。
- `git diff --cached --stat`：8 files changed, 721 insertions(+)。
- 提交命令使用单次命令级身份，未修改 Git 配置：

```text
git -c user.name='21bao TEST_ONLY' -c user.email='[TEST_ONLY_EMAIL]' commit -m 'Implement inventory CSV CLI'
EXIT_CODE=0
```

- 提交结果：`[test-only a1d4a57] Implement inventory CSV CLI`。
- 提交后 `git ls-tree --name-only -r HEAD` 包含：`PLANNER_REPORT.md`、`TASK_SPEC.md`、`TDD_EVIDENCE.md`、`TDD_TASKS.md`、`TEST_ONLY_AUTHORIZATION.md`、`TEST_ONLY_FREEZE.md`、`USER_ALIGNMENT.md`、`USER_BRIEF.md`、`inventory.py`、`test_inventory.py`；不包含 `.audit/` 或 `.input/`。
- 基线到产出的 Diff 统计：

```text
 PLANNER_REPORT.md   |  54 ++++++
 TASK_SPEC.md        |  87 ++++++
 TDD_EVIDENCE.md     | 246 ++++++
 TDD_TASKS.md        |  76 +++++
 TEST_ONLY_FREEZE.md |  25 ++
 USER_ALIGNMENT.md   |  46 +++++
 inventory.py        |  75 +++++
 test_inventory.py   | 112 +++++
 8 files changed, 721 insertions(+)
```

- `git diff --cached --check` 返回 2，仅指出 `TASK_SPEC.md` 与 `TDD_TASKS.md` 中存在既有行尾空格。这两份是本次实验冻结/规划输入，按授权不得修改，故未处理；不影响功能与测试，属非阻断格式观察项。
- 提交后工作树 tracked 文件干净，仅剩 `.audit/`、`.input/` 未跟踪。

产出文件哈希（提交后工作树，与提交内容一致）：

```text
29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4 *inventory.py
fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788 *test_inventory.py
a75b163d783e8af677872a677094e78102f6fa23b4d5a500e3ca73f09328e3d9 *TDD_EVIDENCE.md
```

`WORKER_REPORT.md` 在提交后生成，**不在** Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` 内。

## 实现行为摘要

- 输入：单个本地 UTF-8 CSV 路径参数；首行必须为 `sku,delta`。
- 成功：仅表头是合法空汇总；数据行按 SKU 原样累计，按 Python 字符串顺序排序输出。
- 失败：空文件、错误表头、字段数不为 2、空/纯空白 SKU、非法整数均写 stderr 并返回非零；stdout 不产生表头、部分汇总或成功标记。
- 非空 SKU 首尾空白保留，不做规范化；表头错误与空行均明确失败。
- 仅使用 `csv`、`sys` 标准库；无第三方依赖。

## 结果状态

- **VERIFIED**：基线 HEAD、TASK_SPEC/FREEZE 哈希、Soul 哈希与派发值一致；Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` 已实际创建；14 个标准库测试实际运行并通过，退出码 0；`.audit`/`.input` 未被提交。
- **VERIFIED**：任务 1–5 与任务 7 空文件项存在真实失败后通过记录，原始输出摘录见 `TDD_EVIDENCE.md`。
- **UNVERIFIED**：服务端实际模型身份；授权副本的服务端签名/消息级身份。
- **NOT_RUN**：外部盲审、生产部署、生产 Gate 审批、其他角色阶段。
- **NO RED OBSERVED**：任务 6 原子性测试；任务 7 的仅表头、错误表头、数据空行、空白保留四项。已如实标注，未声称额外 RED。

## 未决事项与建议

1. 任务 6 与任务 7 部分边界未出现 RED，但对应行为已被通过的测试锁定；若审查要求逐项 RED，需要另行授权构造临时缺陷实验，本次未做。
2. 错误文案与具体退出码（本实现失败统一为 1，参数错误为 2）属冻结记录允许的实现细节；本报告不将其升格为生产规格。
3. `git diff --check` 的冻结文档行尾空格为既有内容，修改会破坏哈希与冻结记录，故保持原样。
4. 本报告不构成生产批准或 Gate 通过结论；生产 Gate 仍为 `NOT_APPROVED`。