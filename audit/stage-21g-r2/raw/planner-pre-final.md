## PRE 核查 — stage21g-r2-planner-001

**身份/基线**：task_id STAGE21G-INVENTORY，phase 0.2，role_id planner，Soul 1.1.0（声明 Harness codex / read_only）。受审 Commit `f2fafe432e0102d0249bfa2d6827a5f7c84a449e`，与 TASK.md、BASELINE.json、`git rev-parse HEAD` 三方一致。tracked 文件只有两个：`TEST_ONLY_AUTHORIZATION.md` 和 `USER_BRIEF.md`，提交者为 `21bao TEST_ONLY`，无生产源码；`git diff` 为空，无 tracked 改动。

### 关键证据（VERIFIED）
| 项 | 结果 |
|---|---|
| USER_BRIEF.md | `ee3fa286…745b6` = BASELINE ✓ |
| TEST_ONLY_AUTHORIZATION.md | `64267f…478362` = BASELINE ✓ |
| .audit/planner-r2/TASK.md | `8d4abd…c5a06f` = BASELINE ✓ |
| .input/SOUL.md | `6e00b6…4b50e0b` = TASK 的 Soul SHA = BASELINE `soul_sha256` ✓ |
| .audit/planner-r2/PRE_PROMPT.txt | `cfecae…3817a30` = BASELINE ✓ |

- 角色/模型授权：TEST_ONLY_AUTHORIZATION.md 第 5 行把 planner 列入 Codex 四角色，模型为 `group/gpt-6-luna`，与 TASK.md 的 `requested_model` 一致。**observed_model = UNVERIFIED**（无服务端绑定证据，符合授权声明口径，不冒充）。
- 交付范围：BASELINE `allowed_additions` 恰为 USER_ALIGNMENT.md / TASK_SPEC.md / TDD_TASKS.md / PLANNER_REPORT.md，与 TASK.md 第 13、15 行一致；不写业务代码、不改已有文件。`production_gate: NOT_APPROVED`，未冒充生产 Gate。
- TASK_SPEC `NOT_YET_CREATED` 属 phase 0.2 正常前置状态，按派发口径不计为冻结文件缺失。
- 工作区仅有未跟踪的 `.audit/`、`.input/`（派发材料），无越界痕迹。

### 实质问题（阻断 COMPLIANT）
1. **R2 重派缺少独立用户批准证据**。TEST_ONLY_AUTHORIZATION.md 明文限定“每个角色最多一次真实任务调用、对应一次 PRE 和一次 POST；无自动重派和模型切换”。R2 TASK.md 第 17 行称用户已明确授权新 run_id 及一次 PRE/一次调用/一次 POST，但仓库内唯一的用户授权文件 SHA 仍为 r1 基线原值，无增补、无独立授权记录；该说法仅存在于派发方自己的 TASK 文本中，属自证，不能替代用户批准证据。
2. **r1 原始事件谱系无法核验**。TASK.md 声称“原 PRE UNVERIFIED 的事件和记录继续保留，不覆盖”，但 `.audit/` 下仅有 `planner-r2`，无 r1 的 PRE/POST 记录或日志；`stage21g-planner-001` 仅出现在 `.input/TASK.md`。因此无法证明 r1 planner 是“未启动（0 次调用，本条为第 1 次）”还是“已执行过调用（本条即第 2 次，触及一次性调用上限）”。这正是“状态不明的调用/重试”风险点。

### 观察事项（不单独阻断）
- 未跟踪的 `.audit/`、`.input/` 应作为本次证据链在 POST 后留存；本次只读未改动。
- PRE_PROMPT 中“用户已批准本 TEST_ONLY 范围”与 USER_BRIEF 一致，但同属派发通道自述，不能用来覆盖上述第 1 项缺口。

### 解除阻断的最小条件
提供 r1 的 PRE 原始记录（或调度端明确声明 r1 planner 未启动、调用计数为 0），以及独立于 R2 TASK.md 的用户批准 R2 重派证据；二者可核后重跑本 PRE。

**PRE: UNVERIFIED**（材料、基线、SHA、角色/模型授权与交付范围均可核且无矛盾，但 r1 谱系与 R2 重派授权证据缺失，尚不足以判定符合一次性调用约束，故不允许启动角色）。
