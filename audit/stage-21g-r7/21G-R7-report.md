# Stage 21G-R7 验收报告

## 结论

本轮**技术测试通过，但 R7 整体流程未通过停线要求**。Tester 单次调用执行了新建的 `unittest`：12 项运行、0 失败、0 错误，测试进程退出 0；Tester 原报告为 `GATE_A_PASS`。Pro-Audit POST 原判为 `COMPLIANT`。

然而角色原始事件中出现 `Reconnecting... 2/5 (workspace routing discovery failed)`。用户要求再次出现该错误时停止；调度端在运行中只查看了事件类型，没有及时读取错误内容，未按该要求立即停线。角色随后在 Codex 进程内部重连后继续执行并完成。没有调度端重派或切换模型，但内部重连与及时停线是两件事。因此调度端保留测试事实及 POST 原判，同时判定**R7 本轮停线纪律未满足，整体流程不可作为合规通过的联合验收**。POST 将这一错误列为非阻断观察，未按本轮明确停线要求作出判断；此处明确指出差异，不改写 POST 原文。

| 事项 | 实际结果 |
|---|---|
| 调用环境 | 显式代理后一次调用获得响应并实际执行命令；期间出现一次同名 routing 错误及 CLI 内部重连，环境仍需诊断，不能宣布根因已修复。 |
| Tester | 一次调用，Thread `01a1afa4-6686-7873-91f9-e2253f8f3cec`，`turn.completed`，CLI exit 0；原始事件包含 13 条完成的命令。 |
| 测试技术结果 | 真实独立 `unittest` 12 项、12 项 `ok`、0 failures、0 errors、退出 0；其中 11 个方法有行为断言，1 个无断言、仅记录非法 UTF-8 观察。Tester 原判 `GATE_A_PASS`；不能因此抵消停线偏差。 |
| PRE | 本次独立 PRE 原判 `COMPLIANT`，exit 0，最终 `stop`；R6 PRE 未复用。 |
| POST | 原判 `COMPLIANT`，exit 0，最终 `stop`；它把 routing 错误列作 OBSERVATION，调度端认为这不足以满足用户的硬停线要求。 |
| 已验证能力 | 同一固定 Commit 的 Planner/Worker 历史产出、不同时间独立 Spec/Quality 双审及本次真实 Tester 执行均有各自证据；本轮的错误停线使该次联合流程不能宣称完整合规。 |
| 尚未完成 | Remediation、Gate B、Arbitrator、外部盲审、生产 Gate/部署未执行或未获生产批准。`observed_model` 和服务端绑定仍为 `UNVERIFIED`。 |

## 固定基线与原双审

- R6 报告 Commit：`59297584e95745d7466826080502a3fb610cff97`。
- 实验代码 Commit：`a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`；Tester worktree HEAD 与 tracked diff 复核一致且干净。
- `TASK_SPEC.md` SHA256：`dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c`。
- `TEST_ONLY_FREEZE.md` SHA256：`bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c`。
- R6 MERGE SHA256：`4216ed10566b02b52822596437c433f07753913085ce46b877cd601ea3c660fc`。Spec 与 Quality 均为 `APPROVE_WITH_COMMENTS`，各自 PRE/POST 为 `COMPLIANT`，同 Commit/规格；调度端重算了四份原始审计事件哈希及两份报告哈希。双审为不同时间的独立审查，并非声称同时运行。
- R6 原失败保持 `exit 1`、`turn.failed`、测试 `NOT_RUN`、POST `NON_COMPLIANT`；本次不覆盖这些历史结论。

## 调用预检与代理

| 参数 | R4 Quality 成功原调用 | R6 Tester 失败原调用 | R7 实际调用 |
|---|---|---|---|
| Role | `quality_reviewer` | `tester_gate_a` | `tester_gate_a` |
| Model | `group/gpt-6-luna` | 同左 | 同左 |
| WorkDir | 原 Inventory 项目根 | 固定 Commit 的 Tester worktree | 复用并重新核验 R6 Tester worktree |
| TaskFile | `quality-r3/TASK.md` | `tester-a-r6/TASK.md` | `tester-a-r7/TASK.md` |
| Execute | 是 | 是 | 是 |
| SandboxMode | `danger-full-access` | 同左 | 同左 |
| ProxyUrl | 显式 `http://127.0.0.1:18888` | 未传 | 显式 `http://127.0.0.1:18888` |
| HTTP/HTTPS 环境 | R4 helper 在传参时设置大写变量；调用前继承值及小写变量无独立历史快照 | R6 当时父环境观察为 `20172`，未留子进程环境快照 | 调度端对四个大小写变量显式设置 `18888`；角色子进程独立环境快照未留存 |

R4 原始完成通知提供完整实际调用。R6 原始进程记录使用 helper 默认 CodexExe；helper 默认路径与 R4 显式路径均为同一可执行文件，历史二进制字节一致性没有证据。R7 无模型预览成功，参数包含 `-ProxyUrl`，地址不含凭据；本地 `18888` 为 LISTENING。监听不能证明上游可用，代理差异也不能证明是 R6 故障的唯一根因。未修改全局代理。

## 真实测试与观察

- `item_23`：`python -m unittest discover -s tests_gate_a -p 'test_*.py' -v`。PowerShell 记录 `$LASTEXITCODE=0`；原始 UTF-16 日志显示 `Ran 12 tests`、`OK`，外壳命令 exit 0。测试覆盖汇总、排序、正负零、缺/多字段、空和纯空白 SKU、非法整数、有效前缀后的失败原子性、空文件和空行、仅表头、SKU 空白保留。Worker 历史 14 项未计入。
- `item_26`：单独无效 UTF-8 探针；目标 CLI exit 1、stdout 为空、stderr 为未捕获 `UnicodeDecodeError`；探针外层 exit 0。冻结规格要求 UTF-8 输入，未定义非法字节诊断契约，作为非阻断观察，不预设 BLOCKER。
- `item_29`：只读核验将 UTF-16 日志按 UTF-8 读取，退出 1；`item_31` 随后正确按 UTF-16 读取。这不是 `unittest` 失败。`item_31` 的行尾正则计数为 11，因 PowerShell 输出换行少计一项；`Ran 12` 与原始日志是总数依据。
- 测试范围内仅使用标准库和本地夹具；Codex 模型运行本身需要网络，不能把测试无网络扩展为整个 Harness 无网络。

## 审计、文件与保护

- PRE：Session `ses_e506a9f73ffe7UT6nZBy7K5qmS`；原始事件 SHA256 `8ec28d681fda7196eeaa04f1df96121ace24d891618df1ef0df11daf60ffd9c4`。PRE 另读取自身未列入清单的提示词并列出旧案卷文件名，未发现读取旧案卷私有内容或修改文件；原判保留并记录这一只读范围观察。
- Tester 原始 stdout SHA256：`fe90c801878084bc8c3b16d945018e13138bea990a3669148c2c44da7f9f49f5`。
- POST：Session `ses_e50542331ffexB3d8mlVuWimGj`；原始事件 SHA256 `13f87e279473325921c4e9f1ff5ac8b751cb7aab79fe606ab2d7bd44d0bce4a8`。POST 对 trusted 配置具体差异因未读取备份而列 `UNVERIFIED`；调度端事后以备份和前缀哈希独立闭环。
- Tester 工作树前后新增 6 文件，均在 `tests_gate_a/`；删除 0、修改 0。测试代码 SHA256 `fbd0abb218b791a9d60999f6b063b14c18f1e4b82df7db8aa5bfb74e82d6c3cb`。
- 受控文件最终 **13/13** 匹配。Codex 增加一条实验仓库 trusted 记录；先备份原配置、证明其余字节无未知变化、精确清理该条后，配置 SHA256 恢复 `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`。首次清理前字节校验因路径拼接不匹配失败，未写入；更正后重新校验才写入。
- 本机私有原始证据归档 46/46 哈希一致；其中含配置私有备份，不上传。公开证据为脱敏或转码副本；公开测试日志还移除行尾空白，原始 UTF-16 日志保留在本机。公开文件自身哈希见 `MANIFEST.json`；原日志/原始事件哈希按以上记录核对。

本次授权到 Gate A 及报告为止，未进入其他流程。不得将本地测试结果表述为生产批准。
