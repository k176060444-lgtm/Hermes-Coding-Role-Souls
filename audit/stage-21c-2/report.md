> 发布说明：这是 Stage 21C-2 完成时的报告快照，文末未上传的表述反映报告撰写时的状态；用户随后授权将此报告上传。

# 21bao Stage 21C-2 合成Commit补齐与Codex Sandbox处理报告

## 总结

三套合成仓库已各创建一个本地 Commit 并验证，三份仓库外派发文件已回填各自真实 SHA。Spec Reviewer 负向夹具保留无 Git 仓库和无受审 Commit。Codex 的安全受限后端尚未找到：旧版后端源码存在尝试更改 scratch 外系统对象 DACL 的路径，本轮未启动其探针；因此条件性真实模型验证 0 次，未运行四角色重测。以下 VERIFIED 表示本轮取得证据，INFERRED 表示推断，UNVERIFIED 表示尚无证据。

## 1. 基线与合成仓库

- VERIFIED：固定诊断 Commit [`4f59d6c5489a285e31a05b18af7da9d231721ec2`](https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/commit/4f59d6c5489a285e31a05b18af7da9d231721ec2) 确含 `audit/stage-21c/report.md` 与 `fixture_manifest.json`。
- VERIFIED：三个 project 仓库分别执行了 `git rev-parse --show-toplevel`、`git status --short --untracked-files=all`、`git diff --cached`、`git diff --cached --check`。暂存文件逐一读取，工作区文件字节与暂存对象一致；简易常见密钥模式扫描命中 0。扫描不构成对全部秘密的保证。没有生产资料或意外暂存文件。
- VERIFIED：三个提交是独立仓库中的根提交，身份仅在提交命令用 `-c user.name='21bao Local Agent' -c user.email=21bao-local-agent@localhost` 指定，未设置全局身份；均未推送。提交后 `git log -1`、`git show --stat HEAD` 成功，三个 `git status --short` 均为空。

| 角色 | 合成 Commit | project 内容 |
|---|---|---|
| quality_reviewer | `df21d132ab75c8560c12531b1cf2a6e1aa8a5d39` | TASK_SPEC、toy.py、test_examples.py、defect.diff |
| tester_gate_a | `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf` | TASK_SPEC、toy.py、test_examples.py |
| arbitrator | `f987166becaff6e60e254694fd82ba064e001953` | TASK_SPEC、toy.py、test_examples.py |

三套 `TASK_SPEC.md` 实际 SHA256 均为 `6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45`；三套候选 `toy.py` SHA256 均为 `4277300dbf4bc97271821565e62c683ad2535daa1e46b2f1b60f7b779b82bfde`；三套 `test_examples.py` SHA256 均为 `69dc8397e0c84a8fdf7f87a6370e534a11fac68ad5d962532d7f9a526f0174a6`。quality 的 `defect.diff` SHA256 为 `53e2b8469905a97d6c98af436db4f11bc0794ee53f9d9048aab39002f10795d7`。

三份 `TASK.md` 均在各自 project Git 根目录外，均回填对应实际 Commit、规格 SHA 和已安装 Soul SHA。验证脚本核对 HEAD、清洁状态、工作区规格哈希及派发文件所载 SHA，3/3 一致。每份都声明 SYNTHETIC，不冒充生产批准。重测的模型角色分配仍待届时明确授权。

派发文件及最终 SHA256：

- `C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c-52fk3gqe/fixtures/quality_reviewer/TASK.md`：`b2869823d7f5bc7b89c215828b5e99e8717794c9764631e78d9708ad4ebaceec`
- `C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c-52fk3gqe/fixtures/tester_gate_a/TASK.md`：`e9a0ca02f663d88e3e6a325ebcfc677b5b70cd260534df22ce2c0aa3045066f0`
- `C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c-52fk3gqe/fixtures/arbitrator/TASK.md`：`2c745c3a73181326222e89eba921b8191c384adab345257917675a36b5f6f1c5`

合成上游材料 `tester_gate_a/UPSTREAM_SYNTHETIC.md` SHA256 `e92f75383856a538e4b71ee4d3c84f2e46026684f5a74607f7b4aeb1a261451e`；仲裁案卷 `arbitrator/CASE_SYNTHETIC.md` SHA256 `814b38781223d163d3d61e5afe47a4ca2e15552f006f9bab9d902b4f99e58852`。前者是模拟阶段状态，不是真实双审；后者声明原始/最终候选是同一合成 Commit，盲审、整改、终测均未验证。

Spec Reviewer 负向夹具 `p1-spec-reviewer/project` 的 `git rev-parse --is-inside-work-tree` 返回 128：`fatal: not a git repository (or any of the parent directories): .git`。其 TASK.md SHA256 `23cfdf07609cb7b8976ac04fe72825d419924377a47ca5c5e13457313b4be015`，明确缺受审 Commit，预期 QUESTION/UNVERIFIED，不允许批准类判决。未改该负向夹具。

## 2. Windows 与 Codex

- VERIFIED：Windows 10 Enterprise LTSC 2021、21H2、10.0.19044.7807。
- VERIFIED：`D:/codex/codex-agent.exe --version`：`codex-cli 0.166.0`；EXE SHA256 `9d563ee4e0441ff9d59d612013e0460ddf8e5709735c2d9f6b98b7ef8ca4eb42`。
- VERIFIED：本轮读取了 `codex sandbox --help` 和 `codex exec --help`。前者支持 `-P/--permission-profile`、`--include-managed-config`、`-C` 等；后者支持 `-s read-only` 和 `-s workspace-write`。这些选项的存在不证明可安全运行。
- VERIFIED：用户级 Codex 配置未显式写入 sandbox/approval 设置。上轮会话日志 `turn_context` 为逻辑 `read-only/never`；`C:/Users/KK/.codex/.sandbox/sandbox.2026-11-05.log` 显示对应时段 `MXC availability: false` 和 `Windows sandbox selection: disabled`。这描述的是上轮有效状态，不假称本轮建立过新的 Codex 会话。
- VERIFIED：先前 [Stage 21C 报告](https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls/blob/4f59d6c5489a285e31a05b18af7da9d231721ec2/audit/stage-21c/report.md) 的显式 MXC 无模型 echo 与读取均退出 1，原始错误 `Error: failed to prepare MXC sandbox: native MXC is unavailable on this executor`。本轮遵照要求未重复 MXC。
- UNVERIFIED：之前 `codex_core::tools::router` 返回 `CreateProcess ... Rejected(... blocked by policy)` 的具体决策规则；不能仅凭后端 disabled 或类似 Issue 判断同根因。

## 3. 后端安全分析

- VERIFIED：官方 [Windows Sandbox 文档](https://developers.openai.com/codex/windows/) 说明 `elevated` 需要管理员批准的初始化，涉及专用低权用户、文件权限、防火墙规则和本地策略；`unelevated` 使用受限 token 与基于 ACL 的文件系统边界，网络隔离较弱。
- VERIFIED：固定 tag 源码 [debug_sandbox.rs](https://github.com/openai/codex/blob/rust-v0.166.0/codex-rs/cli/src/debug_sandbox.rs) 的 Windows 旧版分支调用 `run_command_under_windows_session`，而 [legacy.rs](https://github.com/openai/codex/blob/rust-v0.166.0/codex-rs/windows-sandbox-rs/src/unified_exec/backends/legacy.rs) 调用 `apply_legacy_session_acl_rules`。
- VERIFIED：同版本 [spawn_prep.rs](https://github.com/openai/codex/blob/rust-v0.166.0/codex-rs/windows-sandbox-rs/src/spawn_prep.rs) 可能为可写根、拒绝路径和用户权限设置 ACE，也会在相应分支调用 `allow_null_device`；elevated 准备路径也调用该函数。
- VERIFIED：同版本 [acl.rs](https://github.com/openai/codex/blob/rust-v0.166.0/codex-rs/windows-sandbox-rs/src/acl.rs) 的 `allow_null_device` 打开系统 `NUL` 设备并尝试以 `SetSecurityInfo` 设置 DACL。它能否成功依现场权限而定，但不能保证影响仅限 scratch，且本轮没有经验证的完整恢复方案。配置和环境还可能使可写根含 workspace 和临时目录。
- UNVERIFIED：`elevated` 是否已在本机完整配置、该特定本机启动是否会使用既有服务或可否完全恢复。没有执行初始化或启动服务。
- 结论：两种旧版后端在本轮权限约束下不满足“确认只影响 scratch 且可完整恢复”的前置条件；因此未执行可能改变 ACL 或系统对象权限的 `codex sandbox` 直接测试。未将软件启用、安装或升级。

## 4. 本轮探针与 ACL

新探针目录：`C:/Users/KK/AppData/Local/hermes/cache/scratch/stage21c2-vu0bmim0/probe`。两个普通 CMD 对照是 Sandbox 外运行，命令、stdout/stderr 与退出码：

1. `cmd.exe /d /c echo SANDBOX_OK`；exit `0`；stdout `SANDBOX_OK`；stderr 0 字节。保留 `plain-echo.stdout` / `plain-echo.stderr`。
2. `cmd.exe /d /c type sample.txt`；exit `0`；stdout `STAGE21C2_SAMPLE_OK`；stderr 0 字节。保留 `plain-read.stdout` / `plain-read.stderr`。

`codex sandbox` 有界直接测试：NOT_RUN，原因见第 3 节。其 stdout/stderr/退出码均不存在，不能填 PASS 或虚构错误。`codex exec` 内 `exec_command`：NOT_RUN。条件性真实模型调用：0；未达前置条件，不运行模型。

目录与 sample 文件的 Get-Acl SDDL 快照分别保存在 `acl-before.txt` 和 `acl-after.txt`；两文件 SHA256 均为 `2b5f815255fd32e1d2ab012dfd2b8598e62cbf315f4d368d7af7c5e6aa091a39`。VERIFIED：这两个探针对象的快照一致；不代表对其他路径或系统对象进行了全量 ACL 审计。

## 5. 配置和角色保护

本轮前后 SHA256 一致：

- Codex config.toml `28ef096584cdb51edee96c8a8182afadc5774bbcfc8b16813ac6532406657944`
- OpenCode config.json `65bc7174c17105edfa6be724879ba579a44a2362ba09d18cb10bf8f9b78ff936`
- OpenCode opencode.jsonc `3228e544d38fb57d576a5f976e4636d40a5232a31c27e9fac280b8863c377ff2`
- Codex 辅助脚本 `45c66c330cb89077f048fce5d9573f91349d80ebf93a2a3c57aa5f5bfb9058fd`
- planner `6e00b632b38dee6094523efb1e3c6a02ee17198dd4c13fca43000fe6b1b50e0b`
- quality_reviewer `de7da8db6e94d862f5b83f9e4dd69f759bd2a3927c6853b062f0a64b44fd5207`
- tester_gate_a `e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a`
- arbitrator `741f9388bdaf972bbffbdfdce41bb7e0f0a397b84b850cc16a9bbaed77f17f7f`
- p1-worker `8c946fadc63de290dac99571951661f3aeb9223d1cdba1a2c6d37e5383d659b8`
- p1-spec-reviewer `5226a65f2dafd4a5d69da70ea1d9813581ac324db3aea009432a06cc9bf4ff4d`
- p1-worker-remediation `bcf40563930093f540865750ccd464af2488b952937fcc7172cecb64d76c3a9d`
- p1-tester-gate-b `ecebb0a9231168181fe822d2b1395c036dceca3cf8f1345acc9b6c0338d29640`
- p1-pro-audit `5d14cf901135f844f0d2e578894853bcf0891b62887b2276bf1b5b665fbd29cc`

未主动修改系统 ACL、系统服务、全局 Git 身份、Provider、Soul、Harness 配置、Hermes 或 P1/P0；未操作外机或推送夹具。以上哈希不构成全系统文件审计。

## 6. 下一步

仍需先确定在授权范围内可验证的有界后端及对应恢复方案。若此后另行验证受限 `exec_command` 确实成功、且仍要求用现有角色辅助脚本，则可考虑单次透传仅限 `read-only` / `workspace-write` 的参数，保持现有 Role、Model、TaskFile 和 UTF-8 行为；本轮未修改脚本，透传也不能单独解决底层后端不可用。未验证任何模式可投入四角色重测。

本报告仅存本地 scratch；本轮用户明确禁止修改 GitHub 源码，未上传报告或夹具。
