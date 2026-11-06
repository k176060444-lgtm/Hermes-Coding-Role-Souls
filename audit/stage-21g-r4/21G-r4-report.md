# 21bao Stage 21G-R4 联合实战报告（TEST_ONLY）

## 结论

**BLOCKED / FAIL**。R3 Spec PRE 的路径事实误判经无模型核验后，新 Spec PRE 正确核查并给出 COMPLIANT；本轮真实启动 Spec 和 Quality 各一次。Quality 独立报告为 `APPROVE_WITH_COMMENTS`，POST 原判 `COMPLIANT`；Spec 未完成审查，也未生成正式报告，双审和 Tester Gate A 均未完成。

Spec POST 原判 `NON_COMPLIANT`，其指出报告缺失这一事实有原始事件支持；但 POST 另将实际执行成功的 `find ..` 描述为被拒绝，与原始工具事件矛盾。**Pro-Audit 事实核验可靠性缺陷再次出现**，保留其原文及真实命令，不再补测或重派。此前 R3 失败原判不改写。

## 基线与无模型核验

- 原实验代码 Commit `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`；上游 R3 报告 Commit `f2182027c2f65a2d7f351d22765c568595cd27d2`。R4 开始及审查后 HEAD 不变，tracked 文件无未知改动。
- TASK_SPEC SHA256 `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`；TEST_ONLY_FREEZE SHA256 `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`；源码 `inventory.py` SHA256 `29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4`；测试 `test_inventory.py` SHA256 `fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788`。
- R3 原 META SHA256 `0ddea57fdc7cc54c48b72ff2f77f72f3cdbb31d981592151ec9ebddff40e0a63`。直接解析 `before_sha256`：键是 `.audit/planner-r3/post/pre.jsonl`，对应值为 Planner PRE 的 SHA256（完整值见 FACT_CHECK.json）；`.audit/worker-r3/post/pre.jsonl` 不是该映射键。Worker 文件实际存在、SHA256 为 `cf67004fe434cb6108c6a478857bb578a25036fc246ddd84d58906c386304a1f`。没有证据表明文件被替换。
- R3 本机备份按清单 97/97 哈希一致。R4 用户授权以明确标识的原文节选留案，消息级 ID、签名和精确时间戳不可得，不冒充完整原文或独立签名。
- Quality 复用 R3 原 PRE：run_id `stage21g-r3-quality-reviewer-001`，原 PRE SHA256 `1e2cec5d912870fb05a24db5a823285aa8a249d6a35d3789a1afb94e8c13b779`，原判 `COMPLIANT`、正常 stop；固定 Commit、规格、Soul、模型和任务范围不变。既有记录无该角色 stdout/报告，限定范围扫描 Codex 66 份会话无对应 run_id；这是有限证据，不是所有可能位置均不存在的绝对证明。R4 用户明确授权复用，未重复 Quality PRE。

## 实际调用与判决

| 阶段 | 实际调用 | 结果 |
|---|---:|---|
| R4 Spec PRE / Pro-Audit | 1 | `COMPLIANT`；正确核对 R3 两个路径及哈希；历史失败未改写 |
| Spec Reviewer / OpenCode | 1 | Session `ses_e51d73a27ffer0HO2SYjNnYyal`；事件终止 reason `tool-calls`，未生成 SPEC_REVIEW_REPORT，未完成技术审查 |
| Quality Reviewer / Codex | 1 | 原 R3 run_id，Thread `01a1ae28-c3bc-7623-b53b-e0dd4cc12319`；自写报告 `APPROVE_WITH_COMMENTS` |
| Spec POST / Pro-Audit | 1 | 原判 `NON_COMPLIANT`；报告缺失属实，但对 `find ..` 的事实描述与原事件矛盾，可靠性 FAIL |
| Quality POST / Pro-Audit | 1 | 原判 `COMPLIANT`，保留原 R3 PRE 身份，不冒充新 PRE |
| Tester Gate A | 0 | BLOCKED / NOT_RUN；Worker 的旧自测不冒充 Gate A |
| Remediation / Gate B | 0 | NOT_TRIGGERED；未有完成双审及有效整改案卷 |
| Arbitrator | 0 | BLOCKED / NOT_RUN；案卷不完整 |

**本轮非审计角色实际启动 2 次；Pro-Audit 新调用 3 次**。Quality 的 R3 PRE 是复用，不算本轮新调用。没有自动重派、切换模型或重新运行 Planner/Worker。

## Spec 未交付：事实与责任

派发任务提供了正确 Soul 哈希，但**调度端没有在角色任务中明确写出已准备的 `.audit/spec-r4/SOUL.md` 路径**。这是派发材料疏漏。角色读取了旧的 `.input/SOUL.md`（Planner Soul），发现哈希不同后寻找其他文件，未读取规格/代码正文或写报告。真实事件显示：

1. `find .. -maxdepth 3 ...` 所在 bash 调用 **completed，exit 0**，输出仅展示找到的项目内 `.input/SOUL.md`；不能声称该命令被拒绝。
2. 随后两条尝试 `cd` 至父目录再搜索的 bash 调用状态 `error`，工具返回 “The user rejected permission to use this specific tool call.”；不能推断这是用户亲自点击拒绝。
3. 角色 JSONL 末事件 reason `tool-calls`，CLI 外层退出 0；`SPEC_REVIEW_REPORT.md` 不存在。CLI 退出码不能充当角色完成证据。

Spec POST 正确发现报告缺失和角色未完成，但将 `find ..` 与后续被拒绝的两个命令混淆，进而写“无实际访问”，与原始事件不一致。`evidence/SPEC_POST_CONTRADICTION.json` 保存可复核的命令及审计原文。此错误与 R3 的路径误判属于再次出现的审计事实核验可靠性问题；依用户指示停止重复补测。

## Quality 与缺陷状态

Quality 对同一个固定 Commit 静态审查，自行生成 `QUALITY_REVIEW_REPORT.md`，SHA256 `e26408f0a6a2cb22b9cb71caab812ebc2e784637fa1e5db39d1f0ae9ce81fd7d`。它没有读取 Spec 私人结论，没有运行测试。

其 `OPTIONAL` 观察：无效 UTF-8 输入可能触发未捕获的解码异常，依据 `inventory.py:25–26`、`62–64`；审查员明确标记为**静态推断、未运行复现**。因此本轮**无已确认、可复现的真实缺陷**，不能把该观察写成已验证缺陷，也不能启动无案卷的整改。

R3 Worker 的 14 项 unittest 是先前真实自测，不是本轮 Tester Gate A；R4 **未运行测试，Gate A 命令与退出码 NOT_RUN**。两审员没有完成相互独立的完整双审，Codex/OpenCode 端到端交接仍未闭环。

## 保护、证据与生产边界

- 本轮请求模型：Spec/OpenCode `magpie/group/deepseek-v4.1-flash`，Quality/Codex `group/gpt-6-luna`；服务端实际模型身份 `UNVERIFIED`。
- Codex 自动新增的实验 trusted 记录已备份并精确清理，配置恢复 SHA256 `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`；九份 Soul、辅助脚本和配置 **13/13** 与受控基线一致。
- 原始事件、角色报告、精确事实案卷及文件哈希已保存在本机 R4 证据目录；42/42 归档文件哈希一致。R3 的 97 项历史备份独立保留。
- 本轮未访问外机、部署生产、修改冻结规格或现有 Commit。生产 Gate `NOT_APPROVED`；正式外部物理盲审、完整双审、独立 Gate A、符合条件的终测和完整仲裁仍缺失。
