# 21bao Codex Windows Sandbox诊断与四角色重测准备报告

## 状态

本报告是部分完成报告。未调用 Codex/OpenCode 模型，未运行四角色；没有完成三个合成 Commit，故正向夹具尚不可用于正式重测。没有实施 Sandbox 修复，也没有确认可供四角色重测使用的完整 Sandbox 方案。

标记：VERIFIED = 有实际命令、日志或文件证据；INFERRED = 有根据的推断；UNVERIFIED = 证据不足。

## 1. 环境与既有策略

- VERIFIED：Windows 10 Enterprise LTSC 2021、21H2、10.0.19044.7807。证据：`cmd.exe /d /c ver` 与只读注册表属性查询。
- VERIFIED：`D:/codex/codex-agent.exe`，`codex-cli 0.166.0`，SHA256 `9d563ee4e0441ff9d59d612013e0460ddf8e5709735c2d9f6b98b7ef8ca4eb42`。
- VERIFIED：上轮四个会话的 `turn_context` 是 `sandbox_policy=read-only`、`approval_policy=never`。同时间 `C:/Users/KK/.codex/.sandbox/sandbox.2026-11-05.log` 记录 `MXC availability: false`、`Windows sandbox selection: disabled`。前者是会话逻辑权限配置，后者是 Windows 原生后端选择，不矛盾。
- VERIFIED：用户级 `config.toml` 未显式设置 sandbox_mode、approval_policy 或 windows.sandbox；本地默认路径的 ProgramData OpenAI Codex requirements.toml/config.toml、不带隐藏内容的用户 `.codex/rules`、用户 `managed_config.toml` 均未发现。注册表 `HKLM\\SOFTWARE\\Policies\\OpenAI\\Codex` 下 `RequirementsPath` 键或值不可用。
- UNVERIFIED：云端托管配置或其他未观察到的策略是否生效。不能据本地文件缺失声称无任何托管限制。仅靠当前资料不能锁定 router 的具体拒绝规则。

## 2. 无模型探针

工作目录：`C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c-52fk3gqe/probe`。详细 argv、模式、stdout、stderr、退出码见 `diagnostic_results.json`、`plain_control_results.json`；外部普通 terminal 对照见 `plain_terminal_results.md`。

- VERIFIED：外部 `cmd.exe /d /c echo SANDBOX_OK` 输出 `SANDBOX_OK`，退出 0；`cmd.exe /d /c type sample.txt` 输出 `STAGE21C_READ_OK`，退出 0。terminal 工具输出未独立提供 stderr 字段，因此仅能说输出中无 stderr 内容。
- VERIFIED：Python subprocess 包装的两次普通对照因命令语法错误退出 1；这与 Sandbox 无关，不隐藏失败。最初 stderr 误用 UTF-8 解码，无法逐字恢复；后续同类错误以 GBK 保存。
- VERIFIED：直接显式调用 `D:/codex/codex-agent.exe -c windows.sandbox=\"mxc\" sandbox --include-managed-config --permission-profile :read-only -C <probe> -- C:/Windows/System32/cmd.exe /d /c echo SANDBOX_OK`，以及将尾部命令替换成 `type sample.txt`，均退出 1，stderr 原文：`Error: failed to prepare MXC sandbox: native MXC is unavailable on this executor`。argv 原文以 JSON 证据为准。
- NOT_RUN/UNVERIFIED：旧版 Windows 后端的受限直接 Sandbox 未启动。Codex 0.166.0 源码 `codex-rs/cli/src/debug_sandbox.rs` 的 `run_command_under_windows_session` 说明会协调持久 deny ACL；`codex-rs/windows-sandbox-rs/src/unified_exec/backends/legacy.rs` 在旧版启动路径调用 `apply_legacy_session_acl_rules`。由于用户禁止修改 Windows ACL，未冒险执行该路径。
- UNVERIFIED：`codex exec` 内部模型产生的 `exec_command`；本轮不调用模型，外部及 sandbox 子命令的结果不能代替它。

## 3. 根因与限制

- VERIFIED：上轮 router 在启动命令前返回 `Rejected(... rejected: blocked by policy)`；四个会话均有真实 Windows 后端 `disabled` 日志。Sandbox 模式逻辑层 `read-only` 与实际后端禁用应分开记录。
- INFERRED：原生后端不可用或未启用、且审批为 never，是需要重点排查的条件；当前证据没有给出精确拒绝条件，不能断言这些条件是充分根因。
- VERIFIED：[openai/codex#59314](https://github.com/openai/codex/issues/59314) 报告 0.166.0 的 Windows 11 `read-only` 类似拒绝，及单独的 `workspace-write` split-root 报错；作者称其直接 Sandbox 探针成功。其平台和本机后端状态不同，问题仍 open。该 Issue 是相关外部报告，不是本机同根因或官方确认修复的证明。
- VERIFIED：0.166.0 CLI help 支持 `-s read-only` / `-s workspace-write`；`codex sandbox` 支持 `--permission-profile`、`--include-managed-config`、`-C`。`--include-managed-config` 不排除不透明的云端状态。
- UNVERIFIED：MXC 在本机不可用的底层具体原因；未测试其他 Windows 原生实现，未确定可用受限方案；未证明 `workspace-write` 将起效或修复 router。

## 4. 最小后续方案

1. 保持有界权限和现有全局配置；根据旧版 Sandbox 的 ACL 副作用与本轮禁止修改 ACL 的约束，先由用户决定是否另行授权开展涉及 Sandbox 初始化/ACL 的专项检查。不能声称它必然会更改某个特定 ACL，源码支持的是存在处理和协调路径。
2. 单次 `-s read-only` 用于只读审查、`-s workspace-write` 作为 Tester A 的待验证候选；测试前必须确认实际后端、有效权限与工作目录、managed 限制。Workspace-write 不证明物理上只能写测试目录，也不保证本机可用。
3. 如果继续强制通过现有 `Invoke-P1CodexRole.ps1`，其当前执行分支只传 `exec -m ... -C ... --json -`，没有 Sandbox 参数。未来可经授权最小修改该脚本，增加仅限 `read-only` / `workspace-write` 的单次透传，不动全局配置；本轮未修改。
4. 不建议禁用全部安全限制；不启用、安装或升级软件。

## 5. 四角色测试资料

根目录：`C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c-52fk3gqe/fixtures`。明细：`fixture_manifest.json`。四份 `project/TASK_SPEC.md` 的实际 SHA256 均为 `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45`。

| 角色 | 状态和资料 |
|---|---|
| quality_reviewer | 独立 `project` Git 仓库已初始化；候选源码、规格、Diff、测试样例已暂存；缺陷为 `len(items)` 统计 False；Commit 尚未创建。 |
| tester_gate_a | 独立 Git 仓库与候选文件已暂存；`test_output/` 为拟授权测试目录；模拟上游资料标明不是真实审查；Commit 尚未创建。 |
| arbitrator | 独立 Git 仓库与候选文件已暂存；模拟案卷声明原始/最终候选为同一待创建 Commit，盲审、整改和终测证据明确缺失；Commit 尚未创建。 |
| p1-spec-reviewer | 独立负向目录，没有 Git 仓库或受审 Commit；要求依 Soul 处理缺失证据；预期 QUESTION/UNVERIFIED，禁止批准类判决。 |

三个 Git 仓库 `git diff --cached --check` 均退出 0。TASK.md 的 Commit 是 `PENDING_LOCAL_COMMIT`；不能把暂存树、文件 SHA 或 Git blob SHA 冒充 Commit SHA。模拟阶段状态不是生产审批或真实外机审查。完整真实调用矩阵、实际授权和角色 Soul SHA 在下轮启动前仍需用户确认并填入。

## 6. 下一轮四角色参数与先决条件

- 先取得三项真实合成 Commit，并将 SHA 准确填入各自任务与相关案卷；校验 TASK_SPEC SHA、版本关系和角色输入。负向 Spec Reviewer 保持没有 Commit。
- Codex 三角色仍按当时确认的模型、实际 EXE、独立 project、TASK.md，通过辅助脚本分别传入 `-Role`、`-Model`、`-WorkDir`、`-TaskFile`、`-CodexExe`、`-Execute`；如要使用显式单次 Sandbox 参数，需先另行获准修改脚本并核实该后端安全可用。
- OpenCode 使用 `opencode run --agent p1-spec-reviewer --model <当时批准的 provider/model> --format json --dir <负向project> ...`；当前 help 支持 `--file`。实际任务载入方式及有效模型应在真实重测前核实，不使用自动放行权限。
- 当前没有证据支持直接开始四角色真实重测。

## 7. 配置核对

本轮前后下列 SHA256 一致：

- Codex config.toml：`28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`
- OpenCode config.json：`65bc7174c17105edfa6be724879ba579a44a2362ba09d18cb10bf8f9b78ff936`
- OpenCode opencode.jsonc：`3228e544d38fb57d576a5f976e4636d40a5232a31c27e9fac280b8863c377ff2`
- Codex 辅助脚本：`45c66c330cb89077f048fce5d9573f91349d80ebf93a2a3c57aa5f5bfb9058fd`

9 份角色文件本轮后 SHA 与上轮既有基线一致。所列配置哈希未变；未主动修改 GitHub、Hermes、P1/P0、Provider、全局配置或系统 ACL，未接触外机；没有运行模型或创建 Runner/Bridge。未对整个操作系统做全量状态审计。

## 8. 待确认事项

三个合成仓库的实际 Commit 尚未创建；按本会话对 `git commit` 的二次确认纪律，需用户再确认后才可执行。完成后还须回填真实 SHA 和校验。旧版 Windows Sandbox 诊断可能处理 ACL，因本轮明确禁止修改 ACL而停在静态取证，不请求在本轮绕开限制。
