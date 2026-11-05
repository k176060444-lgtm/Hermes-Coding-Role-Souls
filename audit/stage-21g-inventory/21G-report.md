# 21bao Stage 21G Codex + OpenCode 独立联合实战报告

**结论：BLOCKED / 未完成。** 全新本地 TEST_ONLY 仓库已创建，但 Planner 的一次 PRE 没有产生最终审计结论，Planner 和后续角色未启动。不能据此判断九个角色已具备本地协作能力，也不能将工具进程 exit 0 写成 PRE 通过。

## 21F 历史结案

固定历史依据 Commit `aea6e3a02fb874efe63682aac70d3036d3363b0b`：Spec Reviewer 负向功能测试达标；PRE 存在列父目录行为；POST 错误否认原始命令；21F 整体审计未通过。历史 PRE、角色和 POST 日志保留，未进行 R4，未修改历史判决，也未要求模型重新解释已有事实。

用户明确授权 21G 作为独立 TEST_ONLY 实验，不再以 21F 总体通过为启动条件；这不是生产 Gate 豁免。实验项目不使用 Hermes/P1 生产源码。

## 实验基线

- 项目：`Inventory CSV CLI`；需求原文及用户实验授权记录在新建仓库的 `USER_BRIEF.md`、`TEST_ONLY_AUTHORIZATION.md`。
- 新仓库初始本地 Commit：`f2fafe432e0102d0249bfa2d6827a5f7c84a449e`。它只含实验需求和授权两文件，不是可运行程序或 Worker 代码提交，也未推送至 GitHub。
- Planner Soul SHA256：`6e00b632b38dee6094523efb1e3c6a02ee17198dd4c13fca43000fe6b1b50e0b`；Planner 请求模型 `group/gpt-6-luna`。OpenCode 当前配置及审计请求模型 `magpie/group/deepseek-v4.1-flash`；服务端实际模型身份 `UNVERIFIED`。
- 候选 `TASK_SPEC.md` 当时尚未创建，状态 `NOT_YET_CREATED`；Planner 正是该候选的预期产出者，不冒充已冻结规格。

## Planner PRE：一次真实调用

- 计划 run_id：`stage21g-planner-001`；PRE 由真实 `D:/opencode/opencode.exe run --agent p1-pro-audit --model magpie/group/deepseek-v4.1-flash --format json --dir <audit-copy> <PRE提示正文>` 执行。
- 审计 Session：`ses_e5237157cffefh2hpSPljPImCr`；进程退出码 0；事件末尾为 `step_finish.reason = tool-calls`，没有最终 `PRE: COMPLIANT / NON_COMPLIANT / UNVERIFIED` 判决。
- 审计副本含完整 `.git`、固定 HEAD、需求、授权、角色 Soul、任务及预期文件哈希。事件显示审计员读取这些材料并核对 Git、SHA；尚无完整最终裁决，不以这些局部工具调用冒充 PRE 通过。
- 审计员还尝试切换到实验根目录执行 `ls`/`find`；该次 bash 工具事件的状态为 error，提示 `The user rejected permission to use this specific tool call.`；本轮没有人工拒绝。stderr 实际记录 `permission requested: external_directory ... auto-rejecting`。因此应定性为 **OpenCode 自动拒绝权限请求**，不是用户手动拒绝。请求发生在用户许可的本地实验相关路径，但运行时权限未放行；不得修改权限或绕过。
- 审计会话也调用了本地 `workflow-compliance-audit` 技能，并对本机 OpenCode 配置目录做了只读列举及文件 SHA 核对；完整原始事件保留本机，公开版仅保留必要、脱敏事件。未发现该审计会话修改工作区文件或配置的证据。
- 权限拒绝和缺少最终判决同时发生；现有事件不足以断定拒绝是最终判决缺失的唯一原因。PRE 记录为 **UNVERIFIED**，没有擅自补写审计结论或自动重派。

## 阶段与角色矩阵

| 顺序 / 角色 | 状态 | 事实 |
|---|---|---|
| Planner PRE / p1-pro-audit | UNVERIFIED | 真实调用 1 次；无最终判决；出现一次自动拒绝的目录权限请求 |
| Planner / Codex | NOT_RUN | PRE 未有效通过；没有 Planner Thread 或四份角色报告 |
| Worker / OpenCode | NOT_RUN | 没有 Planner 规格候选、TEST_ONLY 冻结及前置交接 |
| Spec Reviewer / OpenCode | NOT_RUN | 没有 Worker 候选 Commit 和冻结规格 |
| Quality Reviewer / Codex | NOT_RUN | 没有同一候选 Commit；没有独立双审 |
| Tester Gate A / Codex | NOT_RUN | 无候选、双审及考卷；没有运行库存程序测试 |
| Worker Remediation / OpenCode | NOT_RUN | 未进入开发或发现可复现缺陷的阶段 |
| Tester Gate B / OpenCode | NOT_RUN | 无有效整改及前置条件 |
| Arbitrator / Codex | NOT_RUN | 无完整实验案卷及前置阶段证据 |
| 以上未启动角色的 POST | NOT_RUN | 对应角色未实际启动；不虚构 POST |

没有新增业务代码、真实 unittest、业务代码 Commit、测试日志或跨 Harness 交接。用户要求的真实角色间协作本轮尚未发生。

## 文件、配置及调用边界

实验项目当前 HEAD 仍为 `f2fafe432e0102d0249bfa2d6827a5f7c84a449e`。Git status 仅显示调度端在角色调用前准备的未跟踪 `.input/SOUL.md`、`.input/TASK.md`；已跟踪需求和授权文件无变更。真实角色调用数量为 0，Pro-Audit PRE 为 1，POST 为 0。没有自动重试、模型切换、远端节点调用或生产部署。

本次受控文件检查 13/13 匹配：Codex config SHA256 `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`；辅助脚本、两个 OpenCode 配置及九份 Soul 与基线一致。没有调用 Codex，未产生本次 Codex trusted-project 记录。服务器端身份和真实模型路由不能仅凭请求参数确认。

## 验收状态与建议

- **功能：NOT_RUN。** 项目尚无实现，不能判断 CLI 或 unittest 是否正确。
- **协作：NOT_RUN。** 没有 Planner→Worker 规格交接，也没有 Worker→双审/Tester 的固定 Commit 交接；九角色整体本地协作能力仍未验证。
- **流程合规：UNVERIFIED / BLOCKED。** PRE 未完成；禁止把退出码 0 或权限拒绝当作审计最终判决。生产 Gate `NOT_APPROVED`。
- **生产 P1 未覆盖：** 真实用户生产规格批准、完整角色交付与逐 run_id 审计、同 Commit 独立双审、真实准入与终测、正式不同物理节点盲审、生产部署授权与部署验收。此次本来就不授权外部盲审和生产部署。

若用户日后授权补测，应先针对本次 OpenCode `external_directory` 自动拒绝及审计会话未输出最终判决查明原因，形成不增加权限框架、未擅自修改配置的可审查方案；本轮不重派或自动变更权限。不能在相关门禁没有有效结论时继续依赖它的角色。

## 证据口径

本机保留未经删改的原始 `pre.jsonl` 和 `pre.stderr`、审计 Git 副本、实验工作区及其 `.input`。GitHub 只上传必要脱敏派生证据；为避免公开无关个人信息，公开 JSONL 中加载的技能全文及本机配置目录列表输出被替换为原始内容 SHA256 标记，命令、会话、权限拒绝、结果状态及项目相关工具事件保留。清单记录原始与公开版本 SHA256。公开文件不是逐字原始日志。
