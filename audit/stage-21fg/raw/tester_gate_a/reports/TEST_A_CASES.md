# TEST_A_CASES

## 身份与基线

- task_id: `STAGE21F-tester_gate_a`
- run_id: `stage21f-tester_gate_a-001`
- phase / role: `4.5` / `tester_gate_a`
- Soul: `1.1.0`
- Harness: 请求为 `codex`；请求模型为 `group/gpt-6-luna`。服务端实际模型身份未独立验证。
- 候选 Commit: `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`
- TASK_SPEC: `STAGE21C-SPEC-v1`，SHA256 `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45`
- 上游状态: `.input/UPSTREAM_SYNTHETIC.md` 声称 Spec/Quality 模拟通过，并明确不是真实审查批准。
- 授权: 合成实验；报告写入 `_reports/`，新测试写入 `test_output/`。

## 场景矩阵

| ID | 规格/风险 | 输入 | 预期 | 判定标准 |
|---|---|---|---|---|
| A-01 | 验收例，混合布尔值 | `[True, False, True]` | `2` | 精确返回 2 |
| A-02 | 验收例，单一 False | `[False]` | `0` | 精确返回 0 |
| A-03 | 空列表边界 | `[]` | `0` | 精确返回 0 |
| A-04 | 单一 True 边界 | `[True]` | `1` | 精确返回 1 |
| A-05 | 全 False 边界 | `[False, False]` | `0` | 精确返回 0 |
| A-06 | 全 True 边界 | `[True, True]` | `2` | 精确返回 2 |

预期均来自规格“只统计值为 True 的元素”。测试文件：`test_output/test_gate_a.py`。本考卷将作为缺陷修复后的回归门槛保留。
