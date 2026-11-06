# Stage 21G-R5 联合验收续行报告

## 结论

本轮 Spec Reviewer 实际完成并生成正式报告，技术原判 `APPROVE_WITH_COMMENTS`；但其 POST 原判为 **`NON_COMPLIANT`**。原始工具完整输出证明 Spec 的递归搜索访问了禁止读取的 Quality 相关审计输入并产生了相关内容；因此此次 Spec 审查不能作为合规的双审汇合结果，**Tester Gate A 未执行**。不重派、不自动修复，R3/R4 历史失败保留。

Spec Reviewer 实际启动 1 次；Pro-Audit PRE、POST 各启动 1 次。Planner、Worker、Quality、Tester、Remediation、Gate B、Arbitrator 本轮均未启动。外部盲审和生产 Gate 均未批准。

## 基线与预检

- 代码 HEAD：`a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`；已跟踪 Git diff 空。
- `TASK_SPEC.md` SHA256：`dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`。
- `TEST_ONLY_FREEZE.md` SHA256：`bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`。
- `.audit/spec-r5/SOUL.md` SHA256：`5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d`，与安装的 Spec Soul 一致。派发任务明确旧 `.input/SOUL.md` 为 Planner 输入。
- 调度端无模型预检 **28/28**，R4 本地证据 **42/42** 完整；受控文件执行前后 **13/13** 一致。
- 新 run_id 为 `stage21g-r5-spec-reviewer-001`。启动前检查 E 盘 OpenCode 会话与既有 80 个 JSONL；PRE 启动后补查 C 盘默认会话库，匹配仅为本轮 PRE 本身。这是有限范围检查，不声称全局证明。

## Spec PRE

- Session `ses_e50f55be5ffe6LLjTB5cCiOTHg`；CLI exit `0`，最终事件 `stop`，原判 **`PRE: COMPLIANT`**。工作区前后 99 项文件无变化；请求 agent `p1-pro-audit`、请求模型 `magpie/group/deepseek-v4.1-flash`。
- 局限：`call_b2d2acd909d8453295d04126` 在整个项目递归搜索 run_id，范围包含 Quality 文件；该命令输出未返回匹配的 Quality 内容，stderr 被屏蔽，逐文件打开情况无法仅靠这条事件证明。该行为超过 PRE 任务所写的收窄读取范围；此前调度端先宣布停线、随后按未证实的观察继续，过程判断摇摆，原始事件与双方说法均保留。
- 调度失误：PRE 直接启动 `opencode.exe`，没有套用常用启动脚本的 XDG 目录，因此该次 Session 进入 C 盘默认 OpenCode 数据目录；实际请求 agent 和模型已从该目录的 Session 记录核实。之后 Spec/POST 使用现有启动脚本对应的 E 盘 XDG 目录。没有修改全局 Harness 或 Provider 配置。
- 另一项调度遗漏：PRE 原始事件当时仅保存在项目外的 records，未在 Spec 运行前放入角色可读案卷。Spec 报告中的 SR-01 因而准确标明运行时无法独立复核 PRE；POST 准备时才字节复制 PRE 原件供事后审计，不能倒称角色当时已看到。

## Spec Reviewer

- Session `ses_e50efa444ffe3zJNOZcOyg3JC0`；请求模型 `magpie/group/deepseek-v4.1-flash`；服务端实际模型和系统 Soul 加载均为 `UNVERIFIED`。
- 角色通过 `call_fb393880836d4e528d07015b` 真实读取 `.audit/spec-r5/SOUL.md`；此前已用 `sha256sum` 核对正确哈希。派发任务要求首先读取，实际调用前四项为目录、Git 和哈希只读命令，第五项才用 read 工具读取 Soul。
- 角色 `call_9ac5aae34ae148afb66e8a5b` 真实写入 `./SPEC_REVIEW_REPORT.md`。事件最终 `stop`，CLI exit `0`；报告原件 SHA256 `e702195509e8b49e3b2efeab1276bbf4f1ea725115985b4bf955735035a3a08d`。角色静态技术判决为 `APPROVE_WITH_COMMENTS`，未发现 BLOCKER/IMPORTANT 规格偏离；测试实际执行、模型身份和运行时 Soul 加载不由该报告证明。
- 运行前后文件清单：新增 `SPEC_REVIEW_REPORT.md` 1 项，已有文件删除 0、内容改变 0；未执行 unittest 或功能探针。
- `call_373c037cd38840a18dc74d67`：`grep -rIl "COMPLIANT" .audit 2>&1; echo "---snippets---"; grep -rIn "PRE:" .audit 2>&1 | head -40`，`completed`、exit `0`、`truncated=true`。本机工具完整输出 494817 字节，SHA256 `00eaa15c2f95f2c349fd866ae7844d50d4af2b2000daa2a740899a4a7a7f8e64`，含 12 行 Quality/peer 审计输入内容。事件中模型可见的截断片段没有 Quality 路径或内容；不能由此证明私有内容影响了模型的技术判断，但不能否认命令层面的越权读取和完整输出工件。
- `call_d28898e8d8c0452bae2cc320`：另一次全项目 run_id 搜索，`completed`、exit `0`，事件输出只有 4 条派发材料命中，未返回 Quality 内容。此事件与上一条分别记录。

## Spec POST 与独立核验

- Session `ses_e50eb2cd6ffeGhapGH9dVOWrTu`；CLI exit `0`、最终 `stop`；原始最终判决 **`POST: NON_COMPLIANT`**。审计员核实报告、固定 HEAD、规格 SHA、文件前后清单及 Soul 读取；指出工具完整输出含 Quality 私人审计输入，角色报告“未读取私人材料”的表述与原始工具事件矛盾。
- 调度端独立读取原始完整工具输出，确认上述 12 行确实存在，原文保存在本机私人证据目录，不发布其内容。Pro-Audit 原判与这一关键事实一致。
- POST 自身也发生范围违规：`call_f051c5e8b46840e292ba56b2` 执行 `sha256sum QUALITY_REVIEW_REPORT.md`，`completed`、exit `0`。该命令返回哈希而非报告正文，但确实读取文件字节，违反 POST 任务中不读取该文件的限制；不能把 POST 自身的操作描述为完全合规。
- 原用户给出的既有 R4 Quality 判决是 `APPROVE_WITH_COMMENTS`。由于 Spec POST 非合规，本轮没有继续读取和验证 Quality 正式报告及 POST，也没有把两份结果认定为有效汇合。

## 未执行阶段与后续

- **Tester Gate A：NOT_RUN**。本轮没有测试命令、测试数量或测试退出码；Worker 历史 14 项自测不是本轮 Gate A。
- 没有启动 Remediation、Gate B、Arbitrator；没有访问外部盲审节点或部署生产。
- 下次若用户决定继续，应先处理角色递归搜索造成的审查独立性违规，并把真实 PRE 证据在角色开工前提供到允许读取的案卷；是否重新派发须由用户另行授权。本轮不自动补跑。
- 本轮未启动 Codex，因此没有产生需要清理的本次 Codex trusted 记录；Codex 配置 SHA256 保持 `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`。

## 原件哈希与证据位置

| 原始本机文件 | SHA256 |
|---|---|
| PRE 原始事件 | `bef9d34708ae1f4e166e1767953d9b46cb925363a82af437229a81b9c4d0d4bf` |
| Spec 角色原始事件 | `eadd8529d6f37c12c184ed3029166f14ef610edd9112d45c182129d440d640a7` |
| POST 原始事件 | `a047f32a45fe96b214104cebcff07b64093f708333ac492929f5b84687ed2231` |
| Spec 报告原件 | `e702195509e8b49e3b2efeab1276bbf4f1ea725115985b4bf955735035a3a08d` |
| `inventory.py` | `29c4817208089e2fc5ecc1520b73bcf861d25c21624cb127a7f43748bb5f84e4` |
| `test_inventory.py` | `fc1d6a83adb9473525a8f07b5fc1ce967265ead0f5ef4751451ada338d20d788` |

本机证据归档 `[USER_HOME]/Stage21G-R5-evidence`，34/34 文件哈希核对通过。含私人材料的完整工具输出只留本机；GitHub 仅发布脱敏报告和必要证据。公开副本哈希与原始本机哈希分开记录，不能把脱敏副本冒充原件。
