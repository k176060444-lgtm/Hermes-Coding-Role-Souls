# 21bao 角色固化部署说明

**范围仅包含角色配置；不会实现 Hermes/P1 阶段执行器。** 由21bao的 gpt-terra 本地 Agent 操作。不得把 gpt-terra 固定为9个执行角色的默认模型。

## 固定来源

- 仓库：`https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls`
- 发布版本：`1.1.3`
- 本次部署应固定到用户在部署提示词中指定的 Commit，不要直接跟随未来 HEAD。
- 仓库当前为 Public；不要擅自改变可见性。

## 部署前

1. 只读核实当前 GitHub 仓库、固定 Commit、Codex/OpenCode 版本及可执行文件路径。
2. 在独立目录获取固定 Commit，不在 `hermes-agent` 或生产工作目录中操作。Windows 克隆时使用 `git -c core.autocrlf=false clone <仓库URL>`，保持受校验文件的原始字节；校验失败时停止，不自行改写清单。
3. 验证 `SHA256SUMS.txt` 中18项源文件哈希全部匹配，9份 Soul 全部存在。任何失败不得部署。
4. 静态检查文件不含密钥、Token、Cookie或其他不应公开的信息。
5. 不安装、升级、卸载或重启任何软件。

## 安装预览

在仓库根目录运行（Windows PowerShell 5.1 可直接读取本文件；脚本带 UTF-8 BOM）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deployment\Install-P1Roles.ps1
```

脚本默认只预览，不写入文件。检查10个目标路径、CREATE/UNCHANGED/CONFLICT状态及实际输出。

确认预览成功、目标路径正确且没有 CONFLICT 后，才执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\deployment\Install-P1Roles.ps1 -Apply
```

不得使用 `-Force`。如出现冲突，停止并报告。

## 安装目标

- OpenCode：`$HOME\.config\opencode\agents\p1-worker.md`、`p1-spec-reviewer.md`、`p1-worker-remediation.md`、`p1-tester-gate-b.md`、`p1-pro-audit.md`。
- Codex：`$HOME\.codex\p1-roles\planner.md`、`quality_reviewer.md`、`tester_gate_a.md`、`arbitrator.md`，以及 `Invoke-P1CodexRole.ps1`。

Codex当前没有经验证的原生命名Agent注册方式；本包使用Soul文件和轻量Prompt注入辅助脚本，不得称为原生Agent。OpenCode使用原生Markdown Agent定义。不得硬编码角色模型。

## 验证（不调用模型）

- 对安装后的源Soul计算SHA256。OpenCode文件增加frontmatter，须验证其正文与源Soul完全一致。
- 执行 `opencode agent list`，确认5个 `p1-*` Agent是否被发现；未发现则如实标记。不得运行 `opencode run`。
- 执行 `Invoke-P1CodexRole.ps1 -Role planner` 默认预览，确认 Soul 路径；此模式不组装 Prompt，不得使用 `-Execute`。
- 使用 `-PreviewPrompt -TaskFile <输入文件> -PromptOutputFile <新文件>` 在不调用模型的情况下组装完整 Prompt。脚本严格解码 UTF-8（输入可带 BOM），拒绝非法字节与覆盖现有输出，输出无 BOM UTF-8 并回读比较；它带 BOM 以兼容 Windows PowerShell 5.1。
- 记录安装前后配置文件哈希，确认未修改全局Provider、密钥和非P1 Agent。
- 确认未修改或重启Hermes Gateway。

## 单次 Sandbox 参数

真实调用可显式传入 `-SandboxMode`，脚本将该值作为单次 `codex exec -s` 参数。未传入时保持原有行为。`danger-full-access` 不提供沙箱隔离，只能在用户明确授权的任务中使用。此参数不改变全局配置。

## 版本说明

Soul是角色职责的唯一来源。Harness升级后重新核验Agent加载方式；本包不实现正在运行任务的二进制保留、任务级版本固定或恢复机制。不得声称这些能力已完成。
