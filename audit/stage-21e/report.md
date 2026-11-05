# 21bao Stage 21E：Windows Codex 修复与三角色真实验收报告

## 结论与证据等级

- **VERIFIED：单次 Codex 工具探针通过。** 在用户明确指定的 `danger-full-access` 模式下，真实 CLI 和模型返回的 `command_execution` 事件显示 PowerShell 实际读取 `sample.txt`，退出码 0，输出 `CODEX_WINDOWS_EXEC_OK`。本次探针未出现 `blocked by policy`。这一结果只证明该次命令在该模式下可执行，不证明原有受限模式已修复。
- **VERIFIED：辅助脚本已发布并更新本机。** 通过单次可选 `-SandboxMode` 传入 CLI 的 `-s`；未传时保留旧行为。发布及安装前后校验见下文。
- **UNVERIFIED：三角色任务与 Soul 合规。** 三个 PRE 审计虽然 CLI 均退出 0，但各自事件流均没有最终审计结论。审计副本不含 `.git`，审计员试图访问原始目录以核对基线时，被 OpenCode `external_directory` 权限自动拒绝。没有把这些状态当作通过，也没有发起三角色调用或 POST 审计。
- **本报告为阻断阶段报告，非最终验收。** 实际结果、原始事件摘要及哈希见 [evidence.json](./evidence.json)。

## 1. 基线与发布

| 项目 | 实测 |
|---|---|
| 主机 | `KK-PC-Server` |
| 操作系统 | Windows 10 Enterprise LTSC 2021，Build 19044.7807（既有核验；本轮未重新采集 OS 版本） |
| Codex | `codex-cli 0.166.0`，`D:/codex/codex-agent.exe` |
| 发布前 main | `48ea21e83e43030215304b89e93020c87c83059a` |
| 辅助脚本代码提交 | `5de3c3b4b3c4ffa8f2b1fd65c8e697b2e8ba4ae7` |
| 发布方式 | 正常快进，无强推；远端 main、`git ls-remote`、独立克隆 HEAD 一致 |
| 回读 | 远端独立克隆，`SHA256SUMS.txt` 18/18 匹配；脚本 SHA256 与预期一致 |
| 代码范围 | `deployment/Invoke-P1CodexRole.ps1`、`README.md`、`deployment/DEPLOYMENT_21BAO.md`、`roles.json`、`SHA256SUMS.txt`；5 文件 +22/-9 |

代码提交：
https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/commit/5de3c3b4b3c4ffa8f2b1fd65c8e697b2e8ba4ae7

脚本源码：
https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/blob/5de3c3b4b3c4ffa8f2b1fd65c8e697b2e8ba4ae7/deployment/Invoke-P1CodexRole.ps1

## 2. 一次真实 Codex 探针

调用（stdin 为要求读取样本、不修改文件的任务）：

```text
D:/codex/codex-agent.exe exec -m group/gpt-6-luna -C C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21e-81n2mfg9/probe -s danger-full-access --json -
```

进程使用本次进程级本地代理 `http://127.0.0.1:18888`，未修改全局配置。真实 thread ID：`01a1abab-37e2-7e42-801d-0b86b78c7bcf`。CLI 退出码 0；stderr 为空。JSONL 包含以下原始工具事件：

```text
command: "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -Command "Get-Content -LiteralPath .\\sample.txt -Raw"
status: completed
exit_code: 0
aggregated_output: CODEX_WINDOWS_EXEC_OK
```

该会话 `turn_context` 记录 `sandbox_policy.type=danger-full-access`、`permission_profile.type=disabled`、`approval_policy=never`。此模式不提供沙箱隔离，属用户对本次单次调用的明确授权。

样本前后 SHA256 均为 `800253a113ad69945621d240746dc10f46135354d8bcb6af4238d10dddddeeff`；整个探针目录文件清单及哈希相同。请求模型为 `group/gpt-6-luna`；上游实际模型身份 **UNVERIFIED**。

原始探针 JSONL 本地文件：`C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21e-81n2mfg9/probe.stdout.jsonl`；SHA256 与精选事件见 `evidence.json`。

## 3. 脚本安装与静态验证

| 项目 | 结果 |
|---|---|
| 原脚本 SHA256 | `45c66c330cb89077f048fce5d9573f91349d80ebf93a2a3c57aa5f5bfb9058fd` |
| 更新脚本 SHA256 | `fa7ed710027fbeb3065d7c47550691e27ae9e86726cf8889fd4f209ce400db77` |
| 备份 | `C:/Users/KK/.codex/p1-roles/Invoke-P1CodexRole.ps1.backup-stage21e-5de3c3b`，哈希与旧文件相同 |
| PowerShell 5.1 AST | 0 错误 |
| UTF-8 BOM | 存在 |
| 四角色 Prompt | BOM/无 BOM 输入共 8/8 组装与逐字符校验通过 |
| 参数转发 | 使用本地 `.cmd` 测试替身检查默认及 3 种模式的 argv，通过；该替身未调用模型 |
| 其他无模型验证 | 默认预览、无效模式与互斥参数检查通过；共 16 项 |
| 配置与角色保护 | 本机 Codex/OpenCode 配置和 4+5 个角色文件与保护基线一致；只有授权辅助脚本变化 |

完整无模型检查本地文件：`C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21e-81n2mfg9/installed-check/results.json`。

## 4. 三角色 PRE 审计及未运行项

三个本地合成仓库在 PRE 前后均保持同一 HEAD、工作区干净、原文件清单与 SHA256 不变、`git diff HEAD` 为空。三个调用均是 `p1-pro-audit`，请求模型使用当前 OpenCode 默认值 `magpie/group/deepseek-v4.1-flash`；实际服务端模型身份未独立验证。

| 角色 / run_id | 合成 Commit | PRE CLI / 审计结果 | 角色调用 / POST |
|---|---|---|---|
| quality_reviewer / `stage21e-quality_reviewer-001` | `df21d132ab75c8560c12531b1cf2a6e1aa8a5d39` | 退出 0；尝试访问审计目录外的 Git 信息被权限拒绝，最终结论未出现 | NOT_RUN / NOT_RUN |
| tester_gate_a / `stage21e-tester_gate_a-001` | `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf` | 退出 0；原项目目录的 Git 命令被权限拒绝，最终结论未出现 | NOT_RUN / NOT_RUN |
| arbitrator / `stage21e-arbitrator-001` | `f987166becaff6e60e254694fd82ba064e001953` | 退出 0；原项目目录的 Git 命令被权限拒绝，最终结论未出现 | NOT_RUN / NOT_RUN |

三个 JSONL 的最后事件均为 `step_finish`，reason 为 `tool-calls`，没有完成的最终合规记录。stderr 均包含 `permission requested: external_directory ... auto-rejecting`；相应工具事件为 `The user rejected permission to use this specific tool call.` 这表示 CLI 自动拒绝，不是用户手动点击拒绝。

我准备审计材料时复制了工作树文件但遗漏 Git 元数据，导致审计员无法在审计工作目录内验证 Commit；这是本次材料准备缺陷。虽然外部本机检查已核对真实 Commit，但不能用该检查冒充 `p1-pro-audit` 的最终结论。没有更改 OpenCode 权限，也没有自动重试。

三个原始审计流保存在本地 `C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21e-81n2mfg9/audits/`；`evidence.json` 提供原始文件 SHA256、审计 Session ID、拒绝命令、stderr 和基线摘要。为避免将无关的本地技能内容和目录列表整体发布到 Public 仓库，此处发布精选证据及原文件哈希，而非将完整 JSONL 当作公开附件。

## 5. 调用数及后续条件

- Codex 初始探针：**1 次**；退出 0、模型响应和真实命令执行已核验。
- 三个 Codex 角色：**0 次**，任务与 Soul 结果均为 NOT_RUN。
- `p1-pro-audit`：PRE **3 次**，CLI 均退出 0，最终审计结论均未观察到；POST **0 次**。
- 自动重试、模型自动切换、WSL 部署、外机访问：**0 次**。
- 后续若用户授权重新执行 PRE，可使用已准备的三个独立审计目录；每个目录内含对应合成 Commit 的本地 Git 副本，HEAD 与文件 SHA256 均已核对。继续遵守现有权限，不绕过权限拒绝。只有得到有效 PRE 结论后，才按每角色最多一次进行真实调用和 POST 审计。
