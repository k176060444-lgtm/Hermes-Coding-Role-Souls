# TEST_A_EVIDENCE — STAGE21G-INVENTORY

## Identity and baseline

- `task_id`: `STAGE21G-INVENTORY`
- `run_id`: `stage21g-r7-tester-a-001`
- `phase` / `role_id`: `4.5` / `tester_gate_a`
- Soul: version `1.1.0`, SHA256 `e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a`
- Harness / requested model: Codex via `Invoke-P1CodexRole.ps1` / `group/gpt-6-luna`
- Observed model: `UNVERIFIED`; no independent service-side binding evidence was supplied.
- Fixed HEAD: `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` (verified with `git rev-parse HEAD`).
- `TASK_SPEC.md` SHA256: `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`.
- `TEST_ONLY_FREEZE.md` SHA256: `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`.
- R7 PRE event SHA256: `8ec28d681fda7196eeaa04f1df96121ace24d891618df1ef0df11daf60ffd9c4`; receipt SHA256: `e615b53b5660d0af26f1f2fec1a829d070a0f00540ad95cb54e65a3fd0828114`. Receipt run ID matches this run and records `PRE: COMPLIANT`, exit `0`. No R6 PRE was reused.
- `MERGE.json`, both review report hashes, Soul, authorization, and R6 history were independently hashed and matched the supplied case file values. Spec and Quality both recorded `APPROVE_WITH_COMMENTS` for the fixed commit; the reports do not claim simultaneous review or production approval.
- Test code SHA256: `fbd0abb218b791a9d60999f6b063b14c18f1e4b82df7db8aa5bfb74e82d6c3cb`.
- Runtime: Python 3.11 (the executable resolved to `...Python\cpython-3.11-windows-x86_64-none\python.exe`).

## Test run

- Command: `python -m unittest discover -s tests_gate_a -p 'test_*.py' -v`
- Environment set for the child process: `PYTHONDONTWRITEBYTECODE=1`; `PYTEST_ADDOPTS=-p no:cacheprovider`; `TEMP`, `TMP`, and `TMPDIR` all pointed to the resolved `tests_gate_a/tmp` directory.
- Process exit code: `0`.
- Raw output: `tests_gate_a/unittest.log` (PowerShell native redirection produced UTF-16 text).
- Summary from raw output: 12 tests; 12 passed; 0 failures; 0 errors.
- Result: `VERIFIED` for A01–A10. The concrete scenarios and their IDs are in `TEST_A_CASES.md`.

| Test ID | unittest case | Result |
|---|---|---|
| A01 | `test_valid_csv_sums_positive_negative_and_zero_and_sorts_skus` | PASS |
| A02 | `test_header_only_is_an_empty_successful_summary` | PASS |
| A03 | `test_whitespace_around_nonempty_sku_is_preserved` | PASS |
| A04 | `test_missing_field_fails_without_output` | PASS |
| A05 | `test_extra_field_fails_without_output` | PASS |
| A06 | `test_empty_sku_fails_without_output`; `test_whitespace_only_sku_fails_without_output` | PASS |
| A07 | `test_invalid_integer_fails_without_output` | PASS |
| A08 | `test_late_field_count_error_emits_no_partial_summary` | PASS |
| A09 | `test_late_integer_error_emits_no_partial_summary` | PASS |
| A10 | `test_empty_file_and_blank_record_fail_without_output` | PASS |
| A11 | `test_invalid_utf8_behavior_is_recorded_as_unspecified_observation` | PASS as an observation-only test; not a Gate requirement |

## Reviewer observation probe

- Probe command: a Python standard-library subprocess probe invoked `python inventory.py <temporary invalid UTF-8 CSV>`; the fixture was created and automatically removed within `tests_gate_a/tmp`.
- Probe wrapper exit code: `0`; target CLI exit code: `1`.
- Raw output: `tests_gate_a/utf8_observation.log`.
- Observed target stdout: empty.
- Observed target stderr: uncaught `UnicodeDecodeError` traceback (ending at `inventory.py` line 27 during CSV header decoding).
- Classification: `VERIFIED` observation; not a Gate failure. The freeze requires UTF-8 input but does not specify behavior for byte sequences that are not valid UTF-8. Both review reports treated this as optional/non-spec behavior, so this result is not promoted to a blocker.

No third-party packages, network access, external systems, production data, or deployment were used. Existing `inventory.py`, `test_inventory.py`, frozen specifications, review materials, and Git metadata were not modified.
