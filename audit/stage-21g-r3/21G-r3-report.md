# 21bao Stage 21G-R3 联合实战报告（TEST_ONLY）

## 结论

**BLOCKED / FAIL（审计有效性）**。Planner 和 Worker 各实际启动一次，前后 PRE/POST 的原始最终判决均为 COMPLIANT，Worker 真实创建本地实验 Commit 并执行 14 项 unittest；两者交接已有实际证据。后续规格审查 PRE 原始结论虽为 COMPLIANT，但其一条关于审计元数据的事实陈述与原始文件直接矛盾，且给出无证据的“文件替换”解释。根据用户关于证据矛盾不得放行的明确要求，调度端将该次 PRE 判为 FAIL，不接受其作为有效放行；不补派、不切模型。

质量审查 PRE 原始结论 COMPLIANT；但规格审查不能启动，同 Commit 独立并行双审的前置不成立，故两名审查员均未启动。Gate A、后续整改/终测和仲裁没有完整输入，不能宣称联合实战全流程通过。Stage 21F 历史结论仍为 FAIL / UNVERIFIED，本轮并非生产 Gate 豁免。

## 已批准范围与基线

- 本轮新授权只限原 Inventory CSV CLI 本地 TEST_ONLY；不授权生产部署或外部盲审。
- R2 报告固定 Commit：`97bcfc05b56097cf5e1832a213dc862828c5c9ba`；实验初始 HEAD：`f2fafe432e0102d0249bfa2d6827a5f7c84a449e`。
- 本轮授权原文单独保存在本地 `.audit/planner-r3/USER_AUTHORIZATION.md`；可见用户消息转录可用，消息级 ID、签名、精确消息时间戳 UNAVAILABLE，不伪造来源或签名。历史授权单独保存。
- 先做本机无模型预检：历史 R1/R2 PRE 原始事件分别匹配用户指定 SHA256 `3b3d0e21364df374bbb371ca2fbb28dc368f15d7751ea6cc9ca93843a95ee536` / `b9d39216e842ddd8e3b32e15e5a4a5096ac88033ebff0acd310cd5a7c06befda`；检查文件可读、旧报告固定引用、历史调用记录、三轮 run_id、Git HEAD 和所有派发输入哈希。既有记录支持 R1/R2 Planner 未启动，但缺失日志和限定范围会话扫描不是绝对证明。
- Planner 请求 `group/gpt-6-luna`；OpenCode 请求 `magpie/group/deepseek-v4.1-flash`。所有服务端实际模型身份均 `UNVERIFIED`，不能将请求值冒充观察值。

## 角色与审计矩阵

| 角色 | 本轮实际调用 | PRE | 正式交付与角色结果 | POST |
|---|---:|---|---|---|
| Planner / Codex | 1 | COMPLIANT，有效 | 自行生成 USER_ALIGNMENT、TASK_SPEC、TDD_TASKS、PLANNER_REPORT；候选由调度端依用户授权冻结为 TEST_ONLY | COMPLIANT，有效；有真实事件与报告自述不一致的轻微观察 |
| Worker / OpenCode | 1 | COMPLIANT，有效 | 真正 TDD，提交本地 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`；WORKER_REPORT 提交后生成且不在该 Commit | COMPLIANT，有效；运行时 Soul 实际加载和模型服务端身份未独立证明 |
| Spec Reviewer / OpenCode | 0 | 原始 `COMPLIANT`；调度端 **FAIL / 非有效 PRE**，详见证据 | BLOCKED / NOT_RUN | NOT_RUN（角色未启动） |
| Quality Reviewer / Codex | 0 | 原始 COMPLIANT；规格侧有效前置缺失，未启动并行双审 | BLOCKED / NOT_RUN | NOT_RUN（角色未启动） |
| Tester Gate A / Codex | 0 | NOT_RUN | BLOCKED / NOT_RUN；Worker 自测不得冒充独立准入测试 | NOT_RUN |
| Worker Remediation / OpenCode | 0 | NOT_RUN | NOT_TRIGGERED；无已确认整改案卷 | NOT_RUN |
| Tester Gate B / OpenCode | 0 | NOT_RUN | NOT_TRIGGERED；无有效整改 | NOT_RUN |
| Arbitrator / Codex | 0 | NOT_RUN | BLOCKED / NOT_RUN；完整实验案卷不存在 | NOT_RUN |

**非审计角色启动数：2；Pro-Audit 实际调用数：6**（Planner PRE/POST、Worker PRE/POST、两个 Reviewer PRE）。各实际角色一套 PRE/POST，无角色重派。两名 Reviewer 的 PRE 不代表 Reviewer 已启动；它们没有应配的角色 POST。

## 原始证据冲突与阻断

规格审查 PRE 会话 `ses_e51f86a96ffelZ11rmIjc1qmEz` 的原始最终文本在观察项 3 声称，Worker POST 元数据 `before_sha256` 中存在 `.audit/worker-r3/post/pre.jsonl`，值为 `778ae2dc…`，随后又以另一值解释为文件替换的时序差异。

直接解析同一原始 META：`before_sha256` 中相应键实际是 `.audit/planner-r3/post/pre.jsonl`，值为 `778ae2dce7335899a0c7910b7d4698f6839aae0db55c6d1a0a6cb295ac80a89e`；**Worker 路径在该映射里不存在**。Worker 自己的 PRE 原始哈希 `cf67004f…` 是另一份证据。审计员混淆路径并给出缺乏事实依据的解释；这是审计事实错误，不能因模型给出 COMPLIANT 或其 CLI 退出 0 而当作有效 PASS。详见 `evidence/SPEC_PRE_CONTRADICTION.json` 和原始最终文本。该错误不证明真实文件曾被替换，也不证明 Worker 越权。

Worker POST 将 TASK_SPEC 中 Planner 自己的 Codex 请求模型与 Worker 的 OpenCode 请求模型描述为文档张力；应按 Planner 请求上下文理解，不能据此认定 Worker 换模。原审计文本完整保留。

## 真实代码、交接和测试

- 实验 Commit：`a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`，父为 `f2fafe432e0102d0249bfa2d6827a5f7c84a449e`；新增 `inventory.py`、`test_inventory.py` 和 TDD 证据，连同 5 份冻结/规划文档共 8 文件入本地提交。**实验源码未推送**。
- TASK_SPEC SHA256 `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`；冻结记录 SHA256 `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`。角色交接从 Codex Planner 文档到 OpenCode Worker 的真实读取、哈希核验、编码和提交已有日志；双审和 Tester 交接尚未完成。
- Worker 提交后实际运行 `PYTHONDONTWRITEBYTECODE=1 python -m unittest -v`：**14 tests，OK，测试自身退出码 0**。测试包装的外层 shell 固定退出 0，以日志内实际 `EXIT_CODE` 为准；独立 Tester Gate A 未运行。
- TDD 的多个步骤有实际 RED→GREEN 事件；原子性及部分边界首次即通过，角色明确记载没有观察到 RED，未为凑整改插入缺陷。`git diff --cached --check` 返回 2，因冻结文档既有行尾空格；保留原哈希，非功能通过证明。

## 证据与保护

- 原始 CLI JSONL/stdout/stderr 本地保留；公开证据为脱敏副本。`evidence/RAW_EVENT_INDEX.json` 列出 Session/Thread、原始 SHA256 和事件数，`MANIFEST.json` 对公开文件逐一哈希。
- Planner 的 Thread：`01a1adf1-3225-71d1-8393-6c0b16594681`；Worker Session：`ses_e52020c4effehEUt8ze3mMjxY2`。
- Codex 自动新增本实验 trusted 记录：清理前配置 SHA `e29f3f053bb2aa11b385be94941b61535b1c94b0d544a3b3fed1d5d513899cbe`，备份后精确移除该记录，恢复为 `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`；其他配置保留。
- 九份 Soul、辅助脚本、Codex/OpenCode 配置共 13/13 哈希与受控基线一致。未访问外机、发起真实外部盲审、部署或进入生产 P1。
- 公共报告只包含脱敏文书和必要证据；无源码或原始完整日志。完整原始事件和实验仓库保留于本机 scratch，需注意 scratch 会过期清理。

## 分层验收

| 层次 | 状态 | 依据 |
|---|---|---|
| 工具调用 | 局部 VERIFIED | Planner、Worker 各真实调用一次，Session/Thread 和事件可查；模型服务端身份 UNVERIFIED |
| 角色功能 | 局部 VERIFIED | Planner 4 件产物、Worker 代码/本地 Commit/14 项自测存在；其他角色 NOT_RUN |
| Soul/流程合规 | FAIL / UNVERIFIED | Planner、Worker POST 原判通过；Spec PRE 证据事实错误导致该审计无效；实际运行时模型/Soul 部分不可独立证明 |
| 跨 Harness 交接 | 局部 VERIFIED | Codex Planner → OpenCode Worker 成功；双审、Tester、仲裁未完成 |
| 生产 Gate | NOT_APPROVED | 缺真实外部物理盲审、完整本地双审及独立测试、终测和完整仲裁；本轮明确不授权部署 |

历史参考：[21G-R1 报告](https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/blob/dba3ef8949bf70cc1474d7b227dffae338b94c28/audit/stage-21g-inventory/21G-report.md)；[21G-R2 报告](https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/blob/97bcfc05b56097cf5e1832a213dc862828c5c9ba/audit/stage-21g-r2/21G-r2-report.md)；[21F-R3 报告](https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/blob/aea6e3a02fb874efe63682aac70d3036d3363b0b/audit/stage-21f-r3/21F-r3-report.md)。
