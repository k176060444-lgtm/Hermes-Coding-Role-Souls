# TEST_ONLY 规格审查任务

task_id: STAGE21G-INVENTORY
run_id: stage21g-r4-spec-reviewer-001
phase: 3
role_id: p1-spec-reviewer
Harness: OpenCode
requested_model: magpie/group/deepseek-v4.1-flash
observed_model: UNVERIFIED，除非有可核实的服务端证据
固定 Commit: a1d4a578f9334bfcda8004d25a4a43dfef7ebf13
TASK_SPEC SHA256: dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
TEST_ONLY_FREEZE SHA256: bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c
Soul SHA256: 5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d

阅读 USER_BRIEF.md、TASK_SPEC.md、TEST_ONLY_FREEZE.md、本任务、R4 用户授权节选，核对固定 Commit 和哈希。审查固定 Commit 的代码和测试，逐条列出规格条目 → 文件:行号/证据 → 满足、偏离或 UNVERIFIED；列出真实问题及影响，自己写根目录 SPEC_REVIEW_REPORT.md，包括身份、基线、证据、问题与 APPROVE / APPROVE_WITH_COMMENTS / REQUEST_CHANGES / NEEDS_SPECIALIST；关键信息缺失标 QUESTION。

Quality Reviewer 按原 R3 已核验 PRE 独立审查同一 Commit，禁止读取 QUALITY_REVIEW_REPORT.md、其 .audit 输入或任何未正式汇合的私人结论。只静态审查：不执行程序、测试或功能探针，不联网，不改现有文件、代码、测试、规格、配置、.audit 或 Git；仅允许新建 SPEC_REVIEW_REPORT.md。不要加载无关 Skills、调用外机、安装、部署或批准生产 Gate。当前实验为用户授权的 TEST_ONLY，不冒充正式生产审批。若 HEAD 或哈希与指定值不一致，停止并报告。
