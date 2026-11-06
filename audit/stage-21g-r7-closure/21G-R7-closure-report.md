# Stage 21G-R7 结案报告（无模型操作）

## 一、R7 原判保留，不改写

| 项目 | 原判 | 原始事件 SHA256 |
|---|---|---|
| Tester 技术结果 | `GATE_A_PASS`：真实独立 unittest 12 项、12 ok、0 失败、0 错误、测试进程退出 0 | role.stdout `fe90c801878084bc8c3b16d945018e13138bea990a3669148c2c44da7f9f49f5` |
| PRE 原判 | `COMPLIANT`（exit 0，最终 stop） | pre.jsonl `8ec28d681fda7196eeaa04f1df96121ace24d891618df1ef0df11daf60ffd9c4` |
| POST 原判 | `COMPLIANT`（exit 0，最终 stop） | post.jsonl `13f87e279473325921c4e9f1ff5ac8b751cb7aab79fe606ab2d7bd44d0bce4a8` |
| 调度端停线纪律 | `FAIL`：routing 错误再现时未及时停线 | 见 R7 报告及本报告第二节 |
| R7 整体流程 | 不可判合规通过 | 固定报告 Commit `4c8ff2f9dd7ae2b3b1285fe7ea980962dcf0e4c5` |

## 二、POST 派发书停线条款核对（只读 grep 实测）

- `post/POST_PROMPT.txt` SHA256 `5c68c6f3f245e48423a6431a613af23181cfbd37587bb377a9ac7fea68630ac7`：对 `workspace routing`、`Reconnecting`、`停线`、`停止，不自动重派`、`不自动重派` 五个关键词逐行检索，全部 0 命中。**派发书不含 routing 错误立即停线条款。**
- 随 POST 材料送达的 `USER_AUTHORIZATION.md`（SHA256 `2afbb2af…706f422`）第 207、209 行含完整条款原文；POST 事件流 `call_02_1cIXQx0KglyCdlSbYNzA0579` 证实审计员实际读取了该文件。
- **责任定性（依据文件内容，非猜测）：**
  1. **调度漏传成立**：调度端未把授权中的停线硬规则写进 POST 必查项，且角色运行期间调度端自身监控未及时停线（此前已记为调度端纪律 FAIL）。
  2. **审计判断错误不成立**：审计员按收到的派发书将单一 error 事件归类为 OBSERVATION、保留错误原文并列入调用环境待诊断，与其受领指令一致，没有虚构或压制事实。
  3. **边界事实记录**：审计员虽可读授权全文，但未主动把停线不一致升格为流程问题；此为事实观察，不据此把责任改判给审计角色。

## 三、Codex 原始事件时序（唯一 Thread `01a1afa4-6686-7873-91f9-e2253f8f3cec`）

- 流共 58 个 JSON 事件，另加 1 行 helper 横幅；`thread.started` ×1、`turn.started` ×1、`turn.completed` ×1、`turn.failed` ×0。
- 事件索引 2 为**流内唯一** error 事件，文本 `Reconnecting... 2/5 (workspace routing discovery failed)`（文本表示五次内部重连中的第 2 次尝试；流内无 1/5 事件，不做推断）。
- 索引 4 起 CLI 内部重连成功，第一条真实命令（`item_1`）执行；共 13 条完成命令：12 条 exit 0，`item_29` exit 1（把 UTF-16 日志按 UTF-8 读取的只读核验失败，不是 unittest 失败）。
- `item_23`：真实 `python -m unittest discover -s tests_gate_a`，测试进程 `$LASTEXITCODE=0`，原始 UTF-16 日志 `Ran 12 tests`、`OK`。
- `item_26`：无效 UTF-8 独立探针，目标 CLI exit 1、未捕获 `UnicodeDecodeError`；按冻结规格属未定义契约的非阻断观察。
- 角色外层退出码 0；records 目录仅此一组 `role.*`，实际 argv 固定 `-m group/gpt-6-luna`：**无调度端重派、无模型切换**。
- stderr 有 3 条 harness 级 MCP 传输错误（06:55:56–06:56:12Z），不影响 turn 完成。
- 对照 R6：R6 为连续多条 Reconnecting 后 `turn.failed`、exit 1、0 条命令；R7 单条 error 后同 turn 恢复并完成。两次差异的因果仍 `UNVERIFIED`。

## 四、未来 TEST_ONLY 停线规则草案（**待 KK 批准；不追溯适用于 R7**）

1. 临时 `Reconnecting…` 且同 turn 内恢复：`WARN`，完整留痕（事件索引、原文、恢复点），不停线。
2. `turn.failed` 或重连耗尽（末次尝试仍失败）：`STOP`，冻结当前调用，不自动重派、不换模型。
3. 必需交付物缺失、真实越权访问、关键审计事实矛盾：`STOP/FAIL`，保留证据并如实记录。
4. 调度端须对 error 类事件设实时监听点，禁止事后提取代替过程停线。

## 五、结案分类

- **技术能力已验证**：R4 成功代理参数核实并可显式传入；Codex danger-full-access 单次调用可进入角色并真实执行 unittest；同 Commit 独立双审与本次 Gate A 证据链各自完整。
- **流程合规**：R7 停线纪律 `FAIL`（调度端），整体流程不判合规通过；PRE/POST/Tester 原判全部保留。
- **未完成后续 Gate**：Remediation、Gate B、Arbitrator、外部盲审、生产 Gate/部署均 `NOT_RUN`/`NOT_APPROVED`。
- **实际缺陷与待诊断**：routing 错误在 18888 路线仍再现一次（调用环境待诊断，R6 根因 `UNVERIFIED`）；无效 UTF-8 未捕获回溯（非阻断观察）；`item_31` 行尾正则少计一项（统计口径观察）；`observed_model` 与服务端绑定 `UNVERIFIED`。

## 六、保护与交付

- 本次会话新增模型调用 **0**；未重跑任何角色；未修改 Soul、Harness、Provider、规格或历史文件。
- 受控文件复核 **13/13**；本机私有归档复核 **46/46**（含原始事件与配置私有备份，不上传）。
- GitHub 固定报告 Commit `4c8ff2f9dd7ae2b3b1285fe7ea980962dcf0e4c5` 与 main 一致，R7 目录 11 个文件此前已逐文件回读通过。
