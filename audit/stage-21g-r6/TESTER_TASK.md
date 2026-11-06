# Stage 21G R6 — Tester Gate A TEST_ONLY

task_id: STAGE21G-INVENTORY
run_id: stage21g-r6-tester-a-001
phase: 4.5
role_id: tester_gate_a
Harness: Codex
requested_model: group/gpt-6-luna
observed_model: UNVERIFIED，除非存在独立服务端绑定证据。
固定 Commit: a1d4a578f9334bfcda8004d25a4a43dfef7ebf13
TASK_SPEC.md SHA256: dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
TEST_ONLY_FREEZE.md SHA256: bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c
Tester Soul 副本: .audit/tester-a-r6/SOUL.md
Tester Soul SHA256: e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a
本轮用户授权节选: .audit/tester-a-r6/USER_AUTHORIZATION.md
双审正式汇合案卷: .audit/tester-a-r6/MERGE.json；SPEC_REVIEW_REPORT.md 与 QUALITY_REVIEW_REPORT.md 仅位于该案卷目录。
本角色 PRE 原始事件: .audit/tester-a-r6/PRE.jsonl，回执 .audit/tester-a-r6/PRE_RECEIPT.json。

在本独立 worktree 的固定 Commit 上执行独立 Tester Gate A。先核对 Soul、授权、双审案卷、固定 HEAD、两份规格哈希和 PRE 原始事件与回执；关键条件不符则停止并报告。双审是不同时间对同一 Commit 的独立审查，不能写成同时执行或生产批准。

设计并实际执行 Python unittest，包含合理的正向、异常、边界和失败原子性用例，断言依据冻结规格而不是当前实现。使用已提供的原有测试以及新考卷，但不得把 Worker 的历史 14 项自测当成本轮执行。失败必须诚实保留，区分缺陷与规格未定义项；未实际运行一律 NOT_RUN。

**所有新测试、测试产物、日志和临时文件只允许写入 `./tests_gate_a/` 子树。** 唯一允许的新目录是 `tests_gate_a/`；只在此目录生成：
- `tests_gate_a/TEST_A_CASES.md`（带编号、预期与目的的考卷）
- `tests_gate_a/test_*.py`（新增测试代码，至少一份）
- `tests_gate_a/TEST_A_EVIDENCE.md`（实际命令、退出码、日志引用和结果）
- `tests_gate_a/GATE_A_REPORT.md`（固定 Commit、结果、失败、未验证项）
- `tests_gate_a/` 下的必要测试日志和临时夹具。

使用进程内临时环境 `PYTHONDONTWRITEBYTECODE=1`、`PYTEST_ADDOPTS=-p no:cacheprovider`，`TEMP`、`TMP`、`TMPDIR` 指向 `tests_gate_a/tmp`；测试子进程继承这些值，避免在授权目录外产生缓存或临时文件。不要使用 package manager、联网或外机；不得修改 `inventory.py`、原有 `test_inventory.py`、规格、授权材料、既有报告、Git 元数据或本 worktree 其他文件；不允许 commit、修复实现、发起后续 Gate 或生产部署。测试自动创建和清理 `tests_gate_a/` 内临时夹具属于本测试必要过程。

测试命令应能被事后审计逐条核对；在日志中保留原始输出及退出码，明确分别列出每次执行的测试数量、失败及错误，最终由自己写出三份报告。只有充分通过才能给 `GATE_A_PASS`；失败写 FAIL，环境或证据不足写 QUESTION / UNVERIFIED；不得伪造。
