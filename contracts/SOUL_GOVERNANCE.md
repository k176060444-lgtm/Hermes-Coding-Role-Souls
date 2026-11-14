# Role Souls 来源与冻结规则（2026-11-14）

本仓库维护 **9 个本地角色**：`planner`、`worker`、`spec_reviewer`、`quality_reviewer`、`tester_gate_a`、`worker_remediation`、`tester_gate_b`、`arbitrator`、`pro_audit`。此仓库 `roles.json` 的 `soul_version` 和 `soul_sha256` 是新任务候选版本；`SHA256SUMS.txt` 为对应内容校验表。不包含 P0 三席。

P0 `blind_a`/`blind_b`/`blind_c` 由 `Paseo-workflow/souls/` 独立维护。当前拟定职责边界：5bao/9bao 使用 Paseo 原生 SDK，rusty 可选 Hermes A2A 且必须先完成独立证明；并非对当前 Controller 已具备完整 A2A 接入能力的声明。

同步顺序：先固定本仓库来源 Commit，再在 Workflow 独立整改分支复制 9 份**完全相同的字节**并记录来源 SHA 和每个角色 SHA-256；Workflow 新任务从其本地固定副本读取、冻结进任务 Store，现存 E2 `TASK_E2_PHASE1` 仅使用当时冻结内容。不得回填、更改 E2 历史日志、签名或验收证据。

当前 Controller 对最终 Arbitrator 强制调用、rusty 正式 A2A 第三席和 Gate 5.9 证据的硬契约不由 Soul 文件解决；上游必须另行裁定最小接口差异。未裁定前不得宣称完整运行兼容或自动部署。本次提交不更改 Controller、Gate、P0 Quorum、OS 权限或实际运行时配置。
