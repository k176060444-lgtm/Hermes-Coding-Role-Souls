# TDD 证据（TEST_ONLY）

- task_id: STAGE21G-INVENTORY
- run_id: stage21g-r3-worker-001
- 基线 Git HEAD: f2fafe432e0102d0249bfa2d6827a5f7c84a449e
- TASK_SPEC.md SHA256: dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
- TEST_ONLY_FREEZE.md SHA256: bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c
- 环境：Python 3.11.15（`[USER_HOME]\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe`），工作目录为实验仓库根目录。
- 所有测试命令均带进程级 `PYTHONDONTWRITEBYTECODE=1`，运行后未生成 `__pycache__` 或 `*.pyc`。
- 本文件只记录本地 TEST_ONLY 实验结果，不构成生产 Gate 或外部盲审批准。

## 汇总

| 任务 | RED 是否实际观察到 | GREEN 结果 |
| --- | --- | --- |
| 1 有效汇总与排序 | 是（缺少 `inventory` 模块，ImportError） | 1 test OK，exit 0 |
| 2 同 SKU 正负累计与零值 | 是（同 SKU 被覆盖为 -3，期望 2） | 2 tests OK，exit 0 |
| 3 字段数错误与无部分输出 | 是（解包 ValueError，未受控失败） | 5 tests OK，exit 0 |
| 4 空 SKU / 空白 SKU | 是（错误输入返回 exit 0 并输出成功汇总） | 7 tests OK，exit 0 |
| 5 非法整数 | 是（`int('abc')` ValueError 未受控） | 8 tests OK，exit 0 |
| 6 输入整体原子性 | **否**（既有实现已先完整校验/累计，测试首次运行即通过） | 9 tests OK，exit 0 |
| 7 冻结边界 | 部分（仅空文件 StopIteration 为 RED；其余边界测试首次运行即通过） | 14 tests OK，exit 0 |
| 8 完整验收与整理 | 无新增 RED；此前真实 RED 已证明测试可失败 | 14 tests OK，exit 0 |

未为制造整改而故意植入缺陷。任务 8 的“测试可在缺陷存在时失败”由任务 1–5、7 实际观察到的 RED 直接证明，未做临时破坏性变更。

## 任务 1：最小有效输入和排序

命令：

```text
PYTHONDONTWRITEBYTECODE=1 python -m unittest -v test_inventory
```

初次 RED（`inventory.py` 尚不存在）：

```text
ERROR: test_inventory (unittest.loader._FailedTest.test_inventory)
ImportError: Failed to import test module: test_inventory
  File "...\test_inventory.py", line 12, in <module>
    import inventory
ModuleNotFoundError: No module named 'inventory'
Ran 1 test in 0.000s
FAILED (errors=1)
EXIT_CODE=1
```

最小实现后 GREEN：

```text
test_valid_input_summarizes_and_sorts_by_sku (test_inventory.SuccessTests...) ... ok
Ran 1 test in 0.010s
OK
EXIT_CODE=0
```

实现要点：读取 UTF-8 CSV、校验表头、按 SKU 排序后输出；此时仅以字典覆盖保存每个 SKU 的值（尚不累计）。

## 任务 2：同 SKU 正负累计

新增测试输入 `alpha,5`、`alpha,-3`、`beta,0`，期望 `alpha=2`。

RED：

```text
FAIL: test_same_sku_accumulates_positive_negative_and_zero
AssertionError: Lists differ:
[['sku', 'delta'], ['alpha', '-3'], ['beta', '0']] !=
[['sku', 'delta'], ['alpha', '2'], ['beta', '0']]
Ran 2 tests in 0.012s
FAILED (failures=1)
EXIT_CODE=1
```

GREEN（改为 `totals[sku] = totals.get(sku, 0) + delta`）：

```text
test_same_sku_accumulates_positive_negative_and_zero ... ok
test_valid_input_summarizes_and_sorts_by_sku ... ok
Ran 2 tests in 0.007s
OK
EXIT_CODE=0
```

## 任务 3：字段数校验与失败原子性

新增缺字段、多字段、以及“有效前缀后接坏字段数”三类失败测试，均断言退出码非零、stdout 为空、stderr 非空。

RED：

```text
ERROR: test_extra_field_fails_without_success_output
ValueError: too many values to unpack (expected 2)

ERROR: test_missing_field_fails_without_success_output
ValueError: not enough values to unpack (expected 2, got 1)

ERROR: test_valid_prefix_then_bad_field_count_has_no_partial_output
ValueError: too many values to unpack (expected 2)

Ran 5 tests in 0.031s
FAILED (errors=3)
EXIT_CODE=1
```

GREEN（显式 `len(row) != 2` 检查并返回 1；输出仍在全部校验完成后才写入）：

```text
Ran 5 tests in 0.016s
OK
EXIT_CODE=0
```

## 任务 4：空 SKU / 空白 SKU

新增 `,5`（空 SKU）和 `   ,5`（仅空白 SKU）失败测试。

RED：

```text
FAIL: test_empty_sku_fails_without_success_output
AssertionError: 0 == 0

FAIL: test_whitespace_only_sku_fails_without_success_output
AssertionError: 0 == 0

Ran 7 tests in 0.032s
FAILED (failures=2)
EXIT_CODE=1
```

GREEN（使用 `if not sku.strip()` 判空；非空 SKU 原样保留，不做 trim）：

```text
Ran 7 tests in 0.022s
OK
EXIT_CODE=0
```

## 任务 5：非法整数

新增 `alpha,abc` 失败测试。

RED：

```text
ERROR: test_non_integer_delta_fails_without_success_output
  File "...\inventory.py", line 47, in main
    totals[sku] = totals.get(sku, 0) + int(delta_text)
ValueError: invalid literal for int() with base 10: 'abc'
Ran 8 tests in 0.026s
FAILED (errors=1)
EXIT_CODE=1
```

GREEN（捕获 `ValueError`，输出带行号诊断并返回 1，非法值不按 0 处理也不跳过）：

```text
Ran 8 tests in 0.024s
OK
EXIT_CODE=0
```

## 任务 6：输入整体原子性

新增端到端测试：先 `beta,2`、`alpha,5`、`alpha,-3` 三条有效记录，最后 `gamma,oops` 非法整数；断言整次运行失败且 stdout 为空。

结果：该测试首次运行即通过。**未观察到 RED**。原因：任务 1 起实现就采用“先完整读取、校验、累计，全部成功后才写 stdout”的顺序，没有流式部分输出路径，因此不存在可自然触发 RED 的缺陷。执行完整测试后：

```text
Ran 9 tests in 0.027s
OK
EXIT_CODE=0
```

未为此故意引入部分输出缺陷。

## 任务 7：空输入与冻结边界

新增以下边界测试：

- 仅有表头 `sku,delta\n` → 成功，输出仅表头（首次运行即通过）；
- 空文件 → 失败且无输出（RED）；
- 错误表头 `name,value` → 失败（首次运行即通过）；
- 数据中空行 → 按错误列数失败（首次运行即通过）；
- 非空 SKU 首尾空白保留（` alpha ` 与 `beta` 不合并，首次运行即通过）。

空文件 RED：

```text
ERROR: test_empty_file_fails_without_success_output
  File "...\inventory.py", line 27, in main
    header = next(reader)
StopIteration
Ran 14 tests in 0.055s
FAILED (errors=1)
EXIT_CODE=1
```

GREEN（`next(reader, None)`，缺表头时输出诊断并返回 1）：

```text
Ran 14 tests in 0.033s
OK
EXIT_CODE=0
```

说明：只有表头、错误表头、空行、空白保留四项在首次运行时即符合冻结决策，因此没有各自的 RED 观察记录；此处如实标记，不声称额外 RED。

## 任务 8：完整 unittest 验收与整理

REFACTOR：把重复的失败断言辅助方法提取为 `FailureAssertionsMixin`，`BoundaryTests` 与 `ErrorTests` 共用；测试语义和断言强度不变。

整理后完整验收（详细模式）：

```text
PYTHONDONTWRITEBYTECODE=1 python -m unittest -v test_inventory
...
Ran 14 tests in 0.035s
OK
EXIT_CODE=0
```

标准发现方式（与派发要求一致）：

```text
PYTHONDONTWRITEBYTECODE=1 python -m unittest
..............
Ran 14 tests in 0.033s
OK
EXIT_CODE=0
```

## 交付文件哈希（提交前工作树）

```text
dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c *TASK_SPEC.md
bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c *TEST_ONLY_FREEZE.md
b687d33b7fec780bad29adc793191c9c8d7149318e1fab05d84415a88a49ab16 *TDD_TASKS.md
3091b5b4917f63d2a6d474cad3ce4b927deb15ebf4579bc9e9536c038acd3d6d *USER_ALIGNMENT.md
cac988e7d060047c86a5b7e89ac978dbe73f30a72538a6854eb3ce629a12d48a *PLANNER_REPORT.md
29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4 *inventory.py
fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788 *test_inventory.py
```

上述 TASK_SPEC.md 与 TEST_ONLY_FREEZE.md 哈希与冻结记录一致，内容未修改。实际产出 Commit SHA 见提交后生成的 `WORKER_REPORT.md`；本文件随本次实验 Commit 一并提交。