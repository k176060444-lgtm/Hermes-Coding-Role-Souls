# TEST_A_EVIDENCE

## 基线

- 候选 HEAD: `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`（与任务指定 Commit 一致）。
- TASK_SPEC SHA256: `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45`（与任务指定值一致）。
- 测试文件: `test_output/test_gate_a.py`
- 测试文件 SHA256: `e1f30488c249c20e540e0847acbf86e3e7deeb10a9d25f031766ab5194f27321`
- 环境: Python 3.11.15；pytest 9.1.0。
- 限制: 本次仅新增准入测试；未修改源码、已有测试或规格。

## 执行记录

- 命令: `pytest -q test_output/test_gate_a.py`
- 退出码: `2`。收集阶段失败，`ModuleNotFoundError: No module named 'toy'`；此调用没有执行用例。原始输出: `test_output/pytest_gate_a.log`。
- 命令: `python -m pytest -q test_output/test_gate_a.py`
- 退出码: `1`。原始输出: `test_output/pytest_gate_a_module.log`；摘要为 `3 failed, 3 passed`。

## 用例结果

- A-01: **FAIL**，预期 2，实际 3。
- A-02: **FAIL**，预期 0，实际 1。
- A-03: **PASS**，预期/实际 0。
- A-04: **PASS**，预期/实际 1。
- A-05: **FAIL**，预期 0，实际 2。
- A-06: **PASS**，预期/实际 2。
- 失败证据详见 `test_output/pytest_gate_a_module.log`。
