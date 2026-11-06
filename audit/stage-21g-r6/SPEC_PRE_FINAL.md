## PRE_CHECK 记录 — `stage21g-r6-spec-reviewer-001`

**身份**：task_id `STAGE21G-INVENTORY`；phase Spec Review（Phase 3 前置开工）；role `p1-spec-reviewer`；执行者 `p1-pro-audit`（既有 OpenCode）；Harness OpenCode；requested_model `magpie/group/deepseek-v4.1-flash`；observed_model `UNVERIFIED`；本 PRE 唯一一次，read_only，未写入任何文件。

### 基线核对（实际计算，非引用自报）

| 项目 | 实际值 | 期望 | 结果 |
|---|---|---|---|
| HEAD | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` | 同左 | PASS（detached，`rev-parse --abbrev-ref HEAD`=`HEAD`） |
| TASK_SPEC.md SHA256 | `dafc4a31…8258c` | `dafc4a31…8258c` | PASS |
| TEST_ONLY_FREEZE.md SHA256 | `bb1fe989…ce63c` | 同左 | PASS |
| inventory.py SHA256 | `29c48172…f84e4` | BASELINE 同值 | PASS |
| test_inventory.py SHA256 | `fc1d6a83…d788` | BASELINE 同值 | PASS |
| .audit/spec-r6/SOUL.md SHA256 | `5226a65f…ff4d` | `5226a65f…ff4d` | PASS（Soul-Version 1.1.0，`spec_reviewer`，read_only） |
| TASK.md SHA256 | `f976622c…4bec` | BASELINE 同值 | PASS |
| USER_AUTHORIZATION.md SHA256 | `c2f6446c…607f` | BASELINE 同值 | PASS |
| UPSTREAM.json SHA256 | `47a912e7…fcf5` | BASELINE 同值 | PASS |

- 工作树：`git diff --quiet` exit 0、`git diff --cached --quiet` exit 0；tracked 10 项与 HEAD blob 一致，无 tracked 改动。
- 唯一未跟踪项为 `?? .audit/`，系调度方放置的本角色材料，未改动 HEAD/tracked 内容；视为既有派发条件，非偏离。
- `.git` 指向 `.../project/.git/worktrees/spec`，与 BASELINE `git_dir` 一致；worktree 独立。
- `SPEC_REVIEW_REPORT.md`：ABSENT（角色尚未开工，正确）。`.input/`：ABSENT（旧 Planner Soul 未被引入）。未发现 Quality 私人报告/审计材料。
- `PRE.jsonl`、`PRE_RECEIPT.json`：ABSENT——按授权“先保存完整 PRE 原始事件，再启动 Spec”的时序，PRE 运行时不存在属正常。

### 开工条件逐项判定

1. 阶段/角色顺序合法：Planner/Worker 上游摘要均 `COMPLIANT`，Worker 交付 Commit 即当前 HEAD；Spec Review 可开工。
2. Soul 版本、职责、read_only 意图匹配；未从其他目录取用 Soul。
3. 输入齐全：任务书、授权节选、上游摘要、冻结规格、代码与测试文件均在指定路径且哈希一致。
4. Harness/模型与批准值一致；无备用模型、无自动重试/切换迹象。
5. Git 基线、Spec 版本、上游 Commit 引用一致（同 `a1d4a578…`）。
6. 无状态不明调用、未处理违规；未发现重复 5 轮/2 次预算越界。

### 如实披露的 UNVERIFIED（均不单独阻断 TEST_ONLY）

- **observed_model**：仅有 requested 参数与配置声明，无服务端模型身份证据 → `UNVERIFIED`。
- **运行时系统 Soul 实际加载**：只能证明派发文件与 SHA，无法独立证明运行时加载 → `UNVERIFIED`。
- **用户授权消息级证据**：消息 ID、签名、时间戳不可得，文件已自述 `UNAVAILABLE`，未凭空补造。
- **run_id 全域占用**：BASELINE 称两个本机 OpenCode DB 均为 0；该 DB 不在本 PRE 允许路径内，无法独立复核；除该既有范围外不做推断。
- **UPSTREAM.json 中 `planner-r3` PRE 的 `raw_sha256`** 以占位/脱敏形式呈现，原始事件属他角色私人材料，不重算；仅确认摘要级 `COMPLIANT`，原始事件真实性 → `UNVERIFIED`。
- **报告路径后续风险（提示非缺陷）**：TASK.md 要求角色先核验 `PRE.jsonl` 与 `PRE_RECEIPT.json` 哈希一致且 PRE 有效；调度端必须在本 PRE 结束后、启动 Spec 前完成该生成与回执，否则角色应停止。

**结论：`PRE: COMPLIANT`**（必需开工证据充分且一致；上述 UNVERIFIED 均为允许披露项，不构成 TEST_ONLY 阻断，也未添加任何生产审批前提）。