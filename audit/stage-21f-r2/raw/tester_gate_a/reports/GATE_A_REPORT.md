# GATE_A_REPORT — Stage 21F synthetic admission suite

## Decision

**FAIL** for the synthetic candidate under the provided specification. This is a test result only and carries no production approval or downstream-stage authorization.

## Identity

- task_id: `STAGE21F-R2-tester_gate_a`
- run_id: `stage21f-r2-tester_gate_a-001`
- phase / role: `4.5` / `tester_gate_a`
- Soul version: `1.1.0` as supplied in the task prompt; external file hash not independently verified within the read boundary.
- Harness: Codex. Requested model: `group/gpt-6-luna`. Observed model: `UNVERIFIED`.
- Candidate commit: `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`.
- TASK_SPEC SHA256: `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45` (`VERIFIED`).
- Scope: authorized synthetic supplement only.

## Findings

- `TA01` fails: mixed input returns 3 instead of 2.
- `TA02` fails: false-only input returns 1 instead of 0.
- `TA03`–`TA05` pass.
- Effective execution: `2 failed, 3 passed`, pytest exit code `1`; details and raw output are in `TEST_A_EVIDENCE.md` and `test_output/pytest_gate_a.log`.

The failures are consistent with the candidate implementation returning `len(items)` instead of counting only `True` values. The implementation was not changed.

## Required follow-up

Worker should correct the synthetic candidate and submit a new candidate revision for a separately authorized retest. Preserve `test_output/test_gate_a.py` as the admission test paper. Do not interpret this report as a production gate or as authorization to start another role.
