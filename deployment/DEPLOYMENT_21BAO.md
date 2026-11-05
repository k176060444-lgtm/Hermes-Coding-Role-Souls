# 21bao 角色固化部署说明

**范围仅包含角色配置；不会实现 Hermes/P1 阶段执行器。** 请由21bao的 gpt-terra 本地 Agent 操作，遵守用户逐段提示词。不得把 gpt-terra 固定为9个执行角色的默认模型。

## 环境基线（仅作历史记录，部署前必须重新核实）

- Windows 10 LTSC / PowerShell 5.1
- Codex CLI 0.166.0，`D:\codex\codex-agent.exe`；命令入口 `D:\codex\codex.cmd` 处理了特殊代理变量。
- OpenCode 1.19.3，`D:\opencode\opencode.exe`。
- Hermes 是编排器，**此 Session 不更改 Hermes**。

## 发布到用户已创建的 GitHub 仓库（当前 Public）

目标：`https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls`。
用户已经创建仓库，**禁止再执行 `gh repo create`**。2026-11-05 检查时仓库为空、默认分支名称为 `main`。若现场发现 README、其它提交或新文件，必须核实已有历史和内容，禁止强推、覆盖、重置或删除。

1. 将 `hermes-coding-role-souls.zip` 下载到21bao解压；定位包含 `README.md`、`roles.json`、`souls/`、`SHA256SUMS.txt` 的根目录。
2. 验证 `SHA256SUMS.txt` 记载的18个文件 SHA256 全部匹配、9份 Soul 全部存在；清单本身不计入哈希列表。**任何失败不得发布或部署**。
3. 使用 `gh auth status` / `gh api user --jq .login` 验证账号 `k176060444-lgtm`（不输出 Token）。通过 `gh repo view k176060444-lgtm/Hermes-Coding-Role-Souls --json nameWithOwner,visibility,defaultBranchRef` 查询元数据。
4. 仓库**当前为 Public**；不要自行改成 Private，也不要认为它是私有仓库。正式上传前静态检查19个文件不含密钥、内网敏感信息或个人隐私。
5. 确认远端没有已有提交：`git ls-remote https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls.git`；若已有提交，改为安全克隆及追加提交，不允许强推或覆盖未知内容。
6. 空仓库时，在解压后的独立目录执行 `git init -b main`、`git add`、`git commit`，设置 origin 为 `https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls.git` 后正常 `git push -u origin main`。不得在原 `hermes-agent` 目录操作。若已有非空历史，只能在明确无冲突的情况下安全添加缺失文件；遇到冲突或无法判断则停止。
7. 推送后回读 `main` 的 Commit SHA 和 GitHub tree，逐项比对19个文件名、内容或 Git blob SHA（注意它与 SHA256 清单算法不同）。只有远端核验通过，才能开始本地安装。
8. 若 `gh` 缺失，可使用已授权的 `git`/GitHub 凭据；不要将 Token 写入命令行日志。缺少认证时报告并停止，不能伪称成功。

## 安装预览（默认不写）

在本仓库根目录的 PowerShell 中运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deployment\Install-P1Roles.ps1
```

确认9个目标路径、已有文件冲突和改动清单后，再明确执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deployment\Install-P1Roles.ps1 -Apply
```

如已有不同内容的 `p1-*` 目标文件，脚本会拒绝覆盖；必须先备份、比对差异并获得特定确认，才允许使用 `-Apply -Force`。不要覆盖现有8个非P1 OpenCode agents 或修改全局 `config.json`。

### 安装目标

- OpenCode：`~/.config/opencode/agents/p1-worker.md`、`p1-spec-reviewer.md`、`p1-worker-remediation.md`、`p1-tester-gate-b.md`、`p1-pro-audit.md`。原生 Markdown Agent，采用本地实测适配的 `description` 和 `mode: all`，**不硬编码 model**。
- Codex：`~/.codex/p1-roles/planner.md`、`quality_reviewer.md`、`tester_gate_a.md`、`arbitrator.md`；和 `Invoke-P1CodexRole.ps1`。Codex 0.166.0 不应假称支持原生命名 Agent；命令调用时通过 stdin 注入相应 Soul。

## 验证（不调用其他模型）

- 对每份已安装的 Soul 与源仓库 Soul 计算 SHA256；OpenCode Markdown 文件有额外 frontmatter，验证其**body**与源 Soul 字节一致。
- 执行 `opencode agent list`（只读）确认5个 `p1-*` 名称是否被载入；若 CLI 行为变化，报告 UNVERIFIED，**不调用 opencode run**。
- 执行 `deployment/Invoke-P1CodexRole.ps1 -Role planner`（默认预览，不调用 Codex），确认指向的 Soul 和路径正确。
- 执行 `codex --version` 和 `opencode --version`；不运行 `codex exec`、`opencode run`、不更新任何软件。
- 报告安装前/后的路径、SHA、备份文件、角色映射和未验证内容。确保 Hermes Gateway 未修改、未重启。

## 版本变更说明

Soul 属于内容资产；Harness 升级不能改变其中的职责。版本更新后重新检查 `--help` 和 Agent 文件加载方式，再按现有角色包重新同步。**本轮不解决在途任务二进制保留/恢复**；保留二进制与任务级版本固定由之后的执行流程负责。报告不得保证已实现“升级不影响在途任务”。
