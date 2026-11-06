# TEST_A_CASES — STAGE21G-INVENTORY

- Run: `stage21g-r7-tester-a-001`
- Phase / role: 4.5 / `tester_gate_a`
- Fixed commit: `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`
- Frozen specification: `TASK_SPEC.md` SHA256 `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`; `TEST_ONLY_FREEZE.md` SHA256 `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`
- Test code SHA256: recorded in `TEST_A_EVIDENCE.md` after authoring.

| ID | Requirement / review trace | Scenario and expected result | Risk purpose |
|---|---|---|---|
| A01 | Freeze §1, §4; Spec F8 | Multiple rows, duplicate SKUs, positive, negative, and zero deltas produce exact totals; sorted by Python string order. | Catch wrong aggregation, sign handling, zero omission, and ordering. |
| A02 | Freeze §2 | Header-only input succeeds with header-only empty summary. | Exercise defined empty-data boundary. |
| A03 | Freeze §3; Spec F7 | Nonempty SKU with surrounding spaces remains a distinct, unchanged key. | Detect silent normalization or key merging. |
| A04 | Freeze §4; Spec F9 | Missing-field row fails, writes diagnostics, and leaves stdout empty. | Detect malformed-row acceptance or partial output. |
| A05 | Freeze §4; Spec F9 | Extra-field row fails, writes diagnostics, and leaves stdout empty. | Detect malformed-row acceptance. |
| A06 | Freeze §3–4; Spec F7 | Empty and whitespace-only SKU fail without successful output. | Detect invalid keys entering totals. |
| A07 | Freeze §4; Spec F9 | Non-integer delta fails without successful output. | Detect coercion or silent zero substitution. |
| A08 | Freeze §4; Spec F9 | Valid rows followed by a missing/extra-field error produce no partial summary. | Detect eager output before full validation. |
| A09 | Freeze §4; Spec F9 | Valid rows followed by invalid integer produce no partial summary. | Detect late-error partial success. |
| A10 | Freeze §2; Spec F3/F5/F6 | Empty file and blank data record fail without successful output. | Check frozen header and blank-row decisions. |
| A11 | Quality review §“OPTIONAL”; Spec review §“FYI-1”; Freeze §1 | Probe invalid UTF-8 and preserve actual process result. Encoding-error handling is not specified as a Gate blocker; report as an observation, not a pass/fail criterion. | Resolve the reviewers’ static-only observation without assuming severity. |

The suite uses only `unittest` and the Python standard library. Fixtures are created under `tests_gate_a/tmp`. No frozen specification or existing test was changed.
