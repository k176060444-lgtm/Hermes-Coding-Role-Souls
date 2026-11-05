# TEST_A_EVIDENCE — Stage 21F synthetic admission suite

## Execution context

- Candidate `HEAD`: `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf` (`VERIFIED`).
- Runtime observed in traceback: Python 3.11, Windows; `pytest` executable resolved to `[USER_HOME]\AppData\Local\hermes\hermes-agent\venv\Scripts\pytest.exe`.
- Cache isolation: both invocations used `-p no:cacheprovider`.
- Test SHA256: `325714b7768167a5115e3e528337e08d3646693b99ab12379066927b83bbe80b`.
- Effective run raw output: `test_output/pytest_gate_a.log`, SHA256 `b3ea122a29a525a230e93ecef1d5f381ffe64beaf9e87830b9c3c8afbfdbcfb5`.
- Model identity: requested model is `group/gpt-6-luna`; server-bound observed model evidence was not available, therefore `UNVERIFIED`.

## Commands and results

1. Initial attempt: `pytest -p no:cacheprovider -q test_output/test_gate_a.py`
   - Exit code: `2`.
   - Result: collection error, `ModuleNotFoundError: No module named 'toy'`; zero cases executed.
   - The console output was observed, but this initial attempt's output was not retained as a separate log file. This is `VERIFIED` from the command result, with no persistent raw-log artifact.
2. Effective run: `$env:PYTHONPATH=(Get-Location).Path; pytest -p no:cacheprovider -q test_output/test_gate_a.py`
   - Exit code: `1`.
   - Raw output: `test_output/pytest_gate_a.log`.
   - Summary: `2 failed, 3 passed in 0.11s`.

## Per-case evidence

| ID | Status | Observed |
|---|---|---|
| TA01 | FAIL | Expected 2; actual 3 for `[True, False, True]`. |
| TA02 | FAIL | Expected 0; actual 1 for `[False]`. |
| TA03 | PASS | Empty list returned 0. |
| TA04 | PASS | `[True]` returned 1. |
| TA05 | PASS | Three true values returned 3. |

No cases were `NOT_RUN` in the effective run. The initial collection attempt did not execute any case.

## Scope and limitations

Only workspace source, TASK_SPEC, `.input` materials and Git metadata were read. Test creation was confined to `test_output/`; reports are confined to `_reports/`. No business source, existing tests, specification, or `.input` file was changed. Config/model declarations in the authorization packet do not establish server-side model identity.
