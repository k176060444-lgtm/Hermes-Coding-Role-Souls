# Spec Reviewer 派发任务草稿 — 待用户另行授权，未执行

此文件只是下一次定向续行的任务草稿，不构成调用授权或已通过 PRE。

task_id: STAGE21G-INVENTORY
run_id: <下次获授权后由调度端分配新的唯一 run_id>
phase: 3
role_id: p1-spec-reviewer
Harness: OpenCode
requested_model: magpie/group/deepseek-v4.1-flash
observed_model: UNVERIFIED，除非有可独立核验的服务端证据
工作目录：原 Inventory 实验仓库根目录（传给 OpenCode 的 --dir 必须指向该目录）
固定 Git Commit: a1d4a578f9334bfcda8004d25a4a43dfef7ebf13
TASK_SPEC.md SHA256: dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
TEST_ONLY_FREEZE.md SHA256: bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c
Spec Reviewer Soul 相对路径: .audit/spec-r4/SOUL.md
Spec Reviewer Soul SHA256: 5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d

开工先读取 `.audit/spec-r4/SOUL.md` 并核对上述 SHA，核对 HEAD、TASK_SPEC 和 TEST_ONLY_FREEZE；任一文件缺失或不符则停止，标 QUESTION / UNVERIFIED，不猜测替代路径。

**`.input/SOUL.md` 和 `.input/TASK.md` 是旧 Planner 输入，不是当前 Spec Reviewer 的 Soul 或任务，不得作为当前角色的依据。** `.audit/spec-r4/SOUL.md` 是 Spec Reviewer Soul 的项目内副本；实际 OpenCode Agent 是否被运行时正确加载应根据可得证据判断，不能仅凭副本哈希冒称已独立证明。

允许读取的具体材料：

- `.audit/spec-r4/SOUL.md`；本次调度端实际传入的本任务；
- 仓库内 `USER_BRIEF.md`、`TASK_SPEC.md`、`TEST_ONLY_FREEZE.md`、`TEST_ONLY_AUTHORIZATION.md`；
- 固定 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` 中的 `inventory.py`、`test_inventory.py` 和与任务相关的 Git 只读信息；
- 明确授权后的本轮授权文本及本角色自身 PRE 材料，其路径由实际派发时给出；`WORKER_REPORT.md` 可作为已标注来源的交接材料，不得将其自述冒充独立验证。

禁止读取 `QUALITY_REVIEW_REPORT.md`、Quality 审查私人结论、其角色审计输入或其原始会话；不访问无关项目或全局 Skills。仅静态审查，不运行被审程序、测试或功能探针；不联网、安装、部署、访问外机或修改已存在文件、规格、代码、测试及 Git 元数据。

正式交付文件：仓库根目录 `SPEC_REVIEW_REPORT.md`（相对工作目录 `./SPEC_REVIEW_REPORT.md`），只允许新建这一份报告。逐条对照冻结规格，附文件:行号、证据、实际影响与 QUESTION / UNVERIFIED；结论使用 APPROVE / APPROVE_WITH_COMMENTS / REQUEST_CHANGES / NEEDS_SPECIALIST。不得冒充生产批准、外部盲审或已经运行的测试。

本草稿没有新建、修改或覆盖 Soul、规格或既有报告；未来执行前须经明确授权并重新核验路径、哈希、Git HEAD、历史调用预算及对应 PRE。
