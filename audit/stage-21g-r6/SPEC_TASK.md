# Stage 21G R6 Spec Reviewer — TEST_ONLY

task_id: STAGE21G-INVENTORY
run_id: stage21g-r6-spec-reviewer-001
role_id: p1-spec-reviewer
Harness: OpenCode
requested_model: magpie/group/deepseek-v4.1-flash
observed_model: UNVERIFIED，除非有可独立验证的服务端证据。
Git HEAD: a1d4a578f9334bfcda8004d25a4a43dfef7ebf13
TASK_SPEC.md SHA256: dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
TEST_ONLY_FREEZE.md SHA256: bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c
Soul 路径: .audit/spec-r6/SOUL.md
Soul SHA256: 5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d
PRE 原始事件路径: .audit/spec-r6/PRE.jsonl
PRE 原始事件 SHA 和调度核对：.audit/spec-r6/PRE_RECEIPT.json
用户授权：.audit/spec-r6/USER_AUTHORIZATION.md
上游证据摘要：.audit/spec-r6/UPSTREAM.json

首先读取 `.audit/spec-r6/SOUL.md` 并核对 SHA；再读取 `.audit/spec-r6/PRE_RECEIPT.json` 与 `.audit/spec-r6/PRE.jsonl` 最终判决，核对两者哈希一致且 PRE 有效通过；核对 HEAD、TASK_SPEC、FREEZE。任何不符或关键记录缺失则停止、报告 QUESTION / UNVERIFIED。当前目录是只含固定 Commit 项目内容和本角色材料的独立 Git worktree。

旧 Planner 的 `.input/SOUL.md` 不是本角色 Soul；本 worktree 不应存在该目录，禁止从任何其他目录寻找或读取它。禁止访问原项目、其他 worktree、Quality 私人报告、Quality 审计材料或任何其他角色私人会话。不要扫描父目录、全盘或全局配置，不要使用递归 grep 搜索审计目录或整个项目。

只允许读取本任务、上述指定文件、`USER_BRIEF.md`、`TEST_ONLY_AUTHORIZATION.md`、`inventory.py`、`test_inventory.py`、`TASK_SPEC.md`、`TEST_ONLY_FREEZE.md`，以及当前 worktree 的必要只读 Git 信息；如需只读 Git/哈希命令，明确指定文件路径。仅静态审查，不运行项目、测试或探针，不联网、不安装、不改任何现有文件、Git、代码或规格。

唯一允许新建正式报告：工作目录根的 `./SPEC_REVIEW_REPORT.md`。首行 `Scope reviewed:`，包含固定 Commit、规格 SHA、逐条规格核对、证据与文件行号、问题分级、未验证事项及最终技术判决 APPROVE / APPROVE_WITH_COMMENTS / REQUEST_CHANGES / NEEDS_SPECIALIST。技术判决独立作出，不把 CLI exit 0、Worker 自测或 TEST_ONLY 冒充 Gate A / 生产通过。
