# PRE-CHECK — STAGE21G-INVENTORY / Phase 3 / p1-spec-reviewer / run_id `stage21g-r5-spec-reviewer-001`

角色：`pro_audit`（被审对象为 `p1-spec-reviewer`）；Soul：`.audit/spec-r5/SOUL.md` v1.1.0；Harness：OpenCode；requested_model：`magpie/group/deepseek-v4.1-flash`。
本次仅做开工前只读核查，未读取 `QUALITY_REVIEW_REPORT.md` 或任何 Quality 私人输入，未跑测试、未写文件、未联网。

## 逐项证据

| # | 检查项 | 结论 | 证据 |
|---|---|---|---|
| 1 | Soul 路径唯一性 | VERIFIED | TASK.md L16/L21 指定 `.audit/spec-r5/SOUL.md`，并明示 `.input/SOUL.md` 是旧 Planner Soul。实测 `.input/SOUL.md` 首部为 `# planner — 需求对齐…`、Harness: codex，确认警告准确；本次未以它为依据。 |
| 2 | Soul SHA | VERIFIED | `sha256sum .audit/spec-r5/SOUL.md` = `5226a65f…bf4ff4d`，与 TASK L17、BASELINE L9 一致。 |
| 3 | 安装副本一致性 | VERIFIED（范围有限） | 单点哈希 `[USER_HOME]\.config\opencode\agents\p1-spec-reviewer.md` 同为 `5226a65f…`，内容与副本一致。**仅单文件哈希，不等于运行时已加载**。 |
| 4 | Soul 运行时加载 | UNVERIFIED | 无 OpenCode 会话/系统提示独立证据可证明本次角色实际注入了该 Soul。按用户指示单项不阻断 TEST_ONLY。 |
| 5 | Git HEAD | VERIFIED | `git rev-parse HEAD` = `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`，与 TASK L13、BASELINE L3 一致；`git log -1` 时间 2026-11-06 07:18:25 +0800。 |
| 6 | 工作区基线 | VERIFIED | `git diff --stat HEAD` 为空（已跟踪文件无改动）；未跟踪项仅 `.audit/`、`.input/`、`QUALITY_REVIEW_REPORT.md`、`WORKER_REPORT.md`，与实验仓形态一致。`f2fafe4…`（冻结记录原基线）为 HEAD 祖先。 |
| 7 | TASK_SPEC SHA 与冻结 | VERIFIED（附观察） | `dafc4a31…8258c` 实测，与 FREEZE L7、TASK L14、BASELINE L11 三方一致。OBSERVATION：TASK_SPEC.md L3 仍写“候选，未冻结”，而 `TEST_ONLY_FREEZE.md` L25 声明 FROZEN——因冻结以引用哈希锁定且禁止改动该文件，属冻结后未回写的状态行，无篡改证据，不影响本次受审基线。 |
| 8 | 代码/证据文件哈希 | VERIFIED | `inventory.py` `29c48172…f84e4`、`test_inventory.py` `fc1d6a83…d788`、`TDD_EVIDENCE.md` `a75b163d…8e3d9`、`WORKER_REPORT.md` `7e9ac35d…930e2`，4/4 与 BASELINE L13–16 一致；`WORKER_REPORT.md` 引用的提交为 `f2fafe4…` 与 `a1d4a5…`（仅作交接材料，未当作独立验证）。 |
| 9 | TASK 内容完备性 | VERIFIED（附观察） | TASK SHA `8d1ddfab…ec34f` 与 BASELINE L18 一致；含 task_id/phase 3/role/harness/requested_model/固定 Commit/两份期望 SHA/Soul 路径+SHA/读取允许清单/禁止 Quality 私人结论（L30）/唯一交付 `./SPEC_REVIEW_REPORT.md`（L32）/只读与不跑测试约束（L36）。OBSERVATION：① 未逐字写明“不得读取既有 `./SPEC_REVIEW_REPORT.md`”，但 L23–28 为封闭读取白名单且该文件当前不存在，属隐含覆盖而非实质缺口；② L28 “授权文本路径由实际派发时给出”为占位，调度端须显式传 `.audit/spec-r5/USER_AUTHORIZATION.md`。 |
| 10 | 用户授权 | VERIFIED（披露限制） | `USER_AUTHORIZATION.md` SHA `8c700ef7…68aac` 与 BASELINE L19 一致；其 L3 自述为逐字节选、无消息 ID/签名/时间戳（UNAVAILABLE）。按指示如实披露，不据此增设生产审批前置。授权明载：Spec PRE/角色/POST 各 1、不自动重试、不切模型、Tester Gate A 仅在前置满足后启动、不重跑 Planner/Worker/Quality、不覆盖 R3/R4 FAIL、不进入生产（L11–15、L52–53、L72–93）。 |
| 11 | 交付路径 | VERIFIED | `ls SPEC_REVIEW_REPORT.md` 返回 “No such file or directory”（非零），与“只允许新建该报告”一致，无覆盖既有报告风险。 |
| 12 | run_id 未使用（预算） | UNVERIFIED（有限证据） | 仓库内（排除 `.audit/spec-r5/`）grep `stage21g-r5-spec-reviewer-001` 命中 0；`.audit/spec-r5/` 仅 5 个派发材料、无先前 PRE 输出或角色报告。BASELINE L45–51 声称 opencode DB 匹配 0、扫描 80 条 jsonl 并自陈限制。**限定记录范围，不能证明全局不存在**；无任何先前调用/重试证据，本次为该 1 次授权 PRE。 |
| 13 | 阶段顺序与模型矩阵 | VERIFIED | Phase 3 独立于 Quality 结论（TASK L30 禁止读取；Soul L23 要求不依赖 Quality 先行结论），本次不核对 Quality 报告与提交对齐（明确禁止且非本 PRE 范围），记为不影响 Spec 独立性。requested_model 与授权 L61 逐字一致；“沿用当前批准配置”（L43）无独立服务端核验。 |
| 14 | observed_model | UNVERIFIED | 无独立服务端模型身份证据；请求参数与角色自报均不构成身份证明。按用户指示单项不阻断。 |

## 结论

- 阻断性缺陷：无。限定的 UNVERIFIED 项为 `observed_model`、Soul 运行时加载、run_id 全局未使用（有限扫描），均按用户既定规则不自动阻断 TEST_ONLY。
- 非阻断 OBSERVATION：冻结记录与 TASK_SPEC 内状态行不一致（已由哈希锁定解释）；TASK 对“既有 SPEC_REVIEW_REPORT.md”的禁止为白名单隐含形式；授权节选路径为占位、须在派发时显式给出；授权文本无签名/消息 ID。
- 历史 FAIL 未被覆盖，本次未重跑 Planner/Worker/Quality，未超预算（1 次 PRE，无重试）。

PRE: COMPLIANT