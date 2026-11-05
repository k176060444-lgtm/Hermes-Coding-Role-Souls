# 21bao Stage 21G-R2 联合实战验收报告

**结果：BLOCKED / NOT_RUN。** 本轮 Planner 的新 PRE 给出了完整最终 `UNVERIFIED`，因此 Planner 和依赖它的联合开发阶段均未启动。用户已明确授权本次补跑；阻断原因是调度端没有把此前 PRE 原始记录和独立的本次授权摘录放入审计员当前仓库材料，审计员无法凭该案卷核对调用谱系与授权。不能将其误写为“用户没有授权”。

## 原实验仓库只读核对

- 继续原 Inventory CSV CLI 实验仓库，没有创建第二个 Inventory 项目。Git HEAD：`f2fafe432e0102d0249bfa2d6827a5f7c84a449e`，与用户指定的初始 Commit 一致；tracked `git diff HEAD` 为空。
- `USER_BRIEF.md` SHA256：`ee3fa2866a97f0b1ee0f4c179f6f4ed90b9957b376c9035fbdfba30ec0d745b6`；`TEST_ONLY_AUTHORIZATION.md` SHA256：`64267fc88c1a80730035e829c2121fd99667d1d74926ca9c77a477d289478362`。二者内容及原 `.input` Soul / Task 哈希与上次基线完全一致。
- 原 PRE `records/planner/pre.jsonl` 保留，SHA256 `3b3d0e21364df374bbb371ca2fbb28dc368f15d7751ea6cc9ca93843a95ee536`；上次 `UNVERIFIED` 不改写。其记录目录实测含 BASELINE、PRE JSONL 与 stderr，未见 role.stdout 或 POST 文件；结合上次固定报告，记录的 Planner 实际调用数为 0，不把文件缺失本身说成可密码学证明的全部进程历史。
- 新增的 `.audit/planner-r2/TASK.md`、`PRE_PROMPT.txt`、`BASELINE.json` 是本轮派发输入。原有未跟踪 `.input/SOUL.md`、`.input/TASK.md` 保留。无业务代码或冻结规格变化。

## 新 PRE 与阻断

- 新 run_id：`stage21g-r2-planner-001`。PRE 真实执行一次，使用 `D:/opencode/opencode.exe run --agent p1-pro-audit --model magpie/group/deepseek-v4.1-flash --format json --dir <原实验仓库根目录> <PRE提示正文>`。
- PRE Session：`ses_e522a12f9ffe95a3K3IPfkwWW7`；进程 exit 0，最终事件 `step_finish.reason = stop`；原始 JSONL SHA256 `b9d39216e842ddd8e3b32e15e5a4a5096ac88033ebff0acd310cd5a7c06befda`。与上轮不同，本次没有 `external_directory` 自动拒绝，stderr 为空。
- 审计员核对了 HEAD、需求/授权、Soul、TASK、SHA 和交付范围，认可 Planner 尚未创建 TASK_SPEC 是正常的规划前置状态；明确将服务端实际模型身份标为 UNVERIFIED。最终原判：**`PRE: UNVERIFIED`**。
- 审计原文指出两项缺失：仓库内未提供上次 PRE 原始记录以核对 R1 是否已启动角色；R2 用户批准只在调度端编写的 TASK 文本中转述，没有单独的授权摘录或来源记录供它独立核验。审计员没有说用户未授权，而是说案卷不足以核验。
- 用户的本轮完整消息明确授权 R2 一次新 PRE、符合条件时一次 Planner 和 POST；这项授权确实存在。**调度错误：我没有在 PRE 之前把上次原始事件及本次用户授权来源整理进仓库内审计材料。** 已核对的 R1 原始 PRE 日志仍保留在本机及上次固定报告的脱敏证据中，但本轮 PRE 未拿到它。不能在已结束的审计之后补材料，再把该原判说成 COMPLIANT。
- 角色启动条件是 PRE 明确 COMPLIANT 且与原始事件无实质矛盾。本次不满足；遵守用户对每次新 run_id 最多一次 PRE、不自动重试的要求，没有重跑或改写原判。Planner 没有启动，故没有其 Thread、角色产物或 POST。

## 阶段矩阵

| 角色 / 阶段 | 状态 | 依据 |
|---|---|---|
| Planner PRE / p1-pro-audit | UNVERIFIED | 真实调用 1 次，最终有明确 UNVERIFIED；授权/谱系证据未齐 |
| Planner / Codex | NOT_RUN | PRE 未 COMPLIANT |
| Planner POST | NOT_RUN | Planner 未启动 |
| Worker / OpenCode | NOT_RUN | 无 Planner 候选与 TEST_ONLY 规格冻结 |
| Spec / OpenCode 与 Quality / Codex | NOT_RUN | 无 Worker 候选 Commit 或待审规格 |
| Tester Gate A / Codex | NOT_RUN | 无候选 Commit、双审和测试 |
| Worker Remediation / OpenCode | NOT_RUN | 未进入发现可复现缺陷的阶段，触发条件无法判定 |
| Tester Gate B / OpenCode | NOT_RUN | 无有效整改与上游条件 |
| Arbitrator / Codex | NOT_RUN | 无完整实验案卷与前置条件 |
| 上述未启动角色的 PRE / POST | NOT_RUN | 没有实际角色任务，不虚构审计 |

## 验收与限制

- **工具功能：部分验证。** OpenCode 和 p1-pro-audit 完成一次真实 PRE、正常输出最终判决；本阶段 Codex 未调用。CLI exit 0 不代表 PRE 通过。
- **跨 Harness 交接：NOT_RUN。** 没有 Planner→Worker 规格、Worker→双审/Tester 的 Commit 交接；不能判断九角色已具备完整本地协作能力。
- **Soul 合规与 Pro-Audit：UNVERIFIED / BLOCKED。** 审计员识别了调度材料缺项；PRE 没有通过，无法把角色合规或整条实验链判 PASS。Codex、OpenCode 请求模型分别为 `group/gpt-6-luna`、`magpie/group/deepseek-v4.1-flash`；真实服务端模型身份没有独立绑定证据，保持 UNVERIFIED。
- **真实 Git 与测试：** 实验 HEAD 仍为 `f2fafe432e0102d0249bfa2d6827a5f7c84a449e`，没有 Worker 代码 Commit、库存 CLI 或实际 unittest 日志；测试为 NOT_RUN。
- **配置保护：** Codex config、辅助脚本、两个 OpenCode 配置和九份 Soul 受控文件 SHA 检查为 13/13 匹配；未调用 Codex，未新增本轮 Codex trusted 记录。没有修改 Hermes/P1/P0、访问外机或部署生产。
- **生产 P1：** 真实生产审批、同 Commit 双审、准入与终测、真实物理外部盲审、完整流程审计、生产部署授权与验收均未完成；TEST_ONLY 用户授权不代表这些 Gate 通过。

## 后续需解决的具体证据缺口

在用户未来另行授权前，不自动重派。若后续继续，需要将本次用户 R2 的授权原文及可追溯来源、R1 PRE 原始日志与 SHA、R1 Planner 未启动的已有记录和上次固定报告，作为清晰标注来源的审计输入，提前放入原实验仓库允许的 `.audit` 路径；审计员可核对材料，但调度端文本和缺失日志本身不应被伪装成独立的密码学身份凭证。本次 PRE 原判及原始日志保持不变。

## 证据与隐私

原始 `pre.jsonl`、`pre.stderr`、工作区和上轮日志保留本机。公开 `raw/` 是经隐私脱敏和 JSON 重序列化的派生证据；`MANIFEST.json` 记录原始与公开文件 SHA256。最终审计文本由实际事件提取并脱敏，不由调度端改写其判决。
