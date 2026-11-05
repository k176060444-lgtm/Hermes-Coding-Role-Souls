# Hermes Coding Pipeline — 21bao Role Souls

**版本：1.1.3 | 用途：21bao 本地角色定义与轻量 CLI 部署 | 原始 P1 源码基准：`38c76de3f7e8b47951b01d430806fffe10fe1cdc`**

本仓库只存放 **9 个21bao本地角色的完整 Soul**、统一输入输出约定和简单部署文件。目标仓库已由用户建立：`k176060444-lgtm/Hermes-Coding-Role-Souls`（目前为 Public；本角色包不含密钥）。它不是 Hermes 或 P1 引擎的替代实现。

## 角色分配

| Role ID | Harness | 阶段 | 行为权限意图 | 部署标识 |
|---|---|---|---|---|
| `planner` | Codex | 0.2 | 只读 | `p1-planner` |
| `worker` | OpenCode | 2 | 工作区读写 | `p1-worker` |
| `spec_reviewer` | OpenCode | 3 | 只读 | `p1-spec-reviewer` |
| `quality_reviewer` | Codex | 4 | 只读 | `p1-quality-reviewer` |
| `tester_gate_a` | Codex | 4.5 | 仅测试文件 | `p1-tester-gate-a` |
| `worker_remediation` | OpenCode | 5.1 | 工作区读写 | `p1-worker-remediation` |
| `tester_gate_b` | OpenCode | 5.2 | 仅测试文件 | `p1-tester-gate-b` |
| `arbitrator` | Codex | 5.3 | 只读 | `p1-arbitrator` |
| `pro_audit` | OpenCode | 全阶段 | 只读 | `p1-pro-audit` |

外部三席 `blind_a`, `blind_b`, `blind_c` 属于 5bao/9bao/rusty，经 P0 A2A 执行，**不在本仓库、本次部署范围内**。它们原先的 Soul 保留在 P1 源仓库，不在此处重复维护。

## 最重要的新增规则

- Planner 首先向用户复述需求、目标、策略、工作流程与架构职责；**通俗准确、无黑话、不乱打比方**，未对齐不能冒充已批准规格。
- Pro-Audit 负责**每个阶段、每个角色、每次由 Hermes/P1 派发的角色任务运行前后的合规检查**，重点包含输入、输出、原始证据、批准与请求模型、实际调用记录、工作范围和阶段交接；这描述角色职责，**不表示当前 P1 已实现自动逐步派发**。
- 所有权限为 Soul 中声明的**软约束**，不声称已经建立 OS 强制隔离；默认保持 CLI 原有安全行为。单次显式传入的 Sandbox 模式由调用方决定并承担权限边界。
- 本次本地 Agent 的模型为 **gpt-terra**，仅是部署执行者模型，**不是9个角色的固定模型配置**。各角色模型仍需来自未来获批准的 Matrix，不在本仓库预设或修改。
- Harness 版本可能升级：本次只固化与版本无关的 Soul 定义，记录部署时的 `codex --version` / `opencode --version`，**不更新、不替换正在使用的二进制**。在途任务版本固定和 CLI 兼容验收由后续调用方处理。

## 1.1.3 修订

- Codex 辅助脚本新增可选 `-SandboxMode`，仅在显式传入时作为单次 `codex exec -s` 参数；未传入时保持原有调用行为。`danger-full-access` 无沙箱，只能在用户明确授权的任务中使用。

## 1.1.2 修订

- Codex 辅助脚本使用 UTF-8 BOM 兼容 Windows PowerShell 5.1；Soul 与 Task 通过严格 UTF-8 解码，有 BOM 与无 BOM 均支持，非法字节会报错。
- `-PreviewPrompt -TaskFile <输入文件> -PromptOutputFile <新文件>` 在不调用模型的情况下组装并回读校验完整 Prompt；输出文件为无 BOM UTF-8，禁止覆盖已有文件。`-PreviewPrompt` 与 `-Execute` 互斥。

## 1.1.1 修订

- 明确 Pro-Audit 必须检查每一次由 Hermes/P1 派发的角色任务运行，不得以主观理由跳过；同一角色任务内部的工具命令不另行派生 Pro-Audit 任务。
- `Install-P1Roles.ps1` 增加 UTF-8 BOM，以兼容 Windows PowerShell 5.1 对无 BOM UTF-8 脚本的默认解码行为；脚本逻辑未改变。

## 仓库结构

- `souls/`：9份独立完整的角色定义；这是职责内容的**唯一来源**。
- `roles.json`：映射与版本信息，未绑定任何实际模型。
- `contracts/ROLE_INPUT.md`：统一角色调用输入清单。
- `contracts/ROLE_OUTPUT.md`：统一报告和证据格式。
- `contracts/PRO_AUDIT_RECORD.md`：Pro-Audit 逐角色前后合规记录格式。
- `deployment/Install-P1Roles.ps1`：**默认预览，不更改任何文件**；显式 `-Apply` 才写本地配置。对目标文件冲突默认拒绝，需 `-Force` 才备份覆盖。
- `deployment/Invoke-P1CodexRole.ps1`：Codex 角色内容装配/调用帮助，默认只预览，真实执行要求显式 `-Execute` 和已批准的 `-Model`。
- `deployment/DEPLOYMENT_21BAO.md`：Windows 21bao 实际部署及验证方式。
- `SHA256SUMS.txt`：源文件哈希清单（不包含清单自身）。

## 关于原生 Agent 支持

- 21bao 已确认 OpenCode 1.19.3 有命名 Agent 和 `--agent`，因此部署为独立的 `p1-*` Markdown Agent（避免覆盖现有8个自定义 Agent）。未设置 model，调用时由批准矩阵决定。
- 21bao Codex 0.166.0 未验证到可直接注册命名角色的 CLI：本仓库把4份 Soul 安装为 `~/.codex/p1-roles/*.md`，用轻量脚本在 `codex exec` 的 stdin 中注入。**不虚称这4份 Soul 已成为 Codex 原生命名 Agent。**

## 范围外

不修改 P1 workflow/executor、Hermes Gateway/插件、OpenCode 现有8个 agent、Codex 原配置、模型供应商与密钥；不创建 P0 盲审作业，不测试付费模型，不部署生产系统。

## 发布与部署

本仓库不能代替用户当前已有的生产仓库。从本仓库固定 Commit 获取源码，核验 SHA256 后执行21bao本地角色安装。仓库已由用户创建并已发布，不要再上传 ZIP、创建同名仓库或修改其他仓库。
