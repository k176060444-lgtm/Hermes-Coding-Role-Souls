# TEST_A_CASES — Stage 21F synthetic admission suite

## Identity and baseline

- task_id: `STAGE21F-R2-tester_gate_a`
- run_id: `stage21f-r2-tester_gate_a-001`
- phase / role: `4.5` / `tester_gate_a`
- Soul version: `1.1.0` (declared; Soul file/hash not independently accessible under this task's read boundary)
- Harness / requested model: Codex / `group/gpt-6-luna` (requested only; observed model is `UNVERIFIED`)
- Candidate commit: `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`
- TASK_SPEC: `TASK_SPEC.md`, SHA256 `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45` (`VERIFIED`)
- Upstream state: `.input/UPSTREAM_SYNTHETIC.md` declares synthetic-only Spec and Quality reviews and intentionally retained defects.
- Authorization: `.input/AUTHORIZATION.md` describes a controlled synthetic retest; no production gate authority.

## Contract under test

`count_done(items)` receives a Boolean list and counts only elements equal to `True`; empty input returns zero. The three acceptance examples in `TASK_SPEC.md` are binding test inputs.

## Case matrix

| ID | Category | Input | Expected | Risk purpose |
|---|---|---|---:|---|
| TA01 | Required mixed case | `[True, False, True]` | 2 | Detect counting list length instead of completed items. |
| TA02 | Required false-only boundary | `[False]` | 0 | Detect false elements being counted. |
| TA03 | Required empty boundary | `[]` | 0 | Verify empty input behavior. |
| TA04 | Positive singleton | `[True]` | 1 | Verify a single completed item is counted. |
| TA05 | Positive all-true | `[True, True, True]` | 3 | Verify all completed items are counted. |

## Test artifact

- Added test module: `test_output/test_gate_a.py`
- SHA256: `325714b7768167a5115e3e528337e08d3646693b99ab12379066927b83bbe80b`
- Existing tests and business source were not modified.
