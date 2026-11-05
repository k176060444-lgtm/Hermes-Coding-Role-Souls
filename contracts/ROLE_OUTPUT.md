# 统一角色输出约定

建议所有角色在自己的专业报告开头记录如下信息。不要求人为伪装成机器签名或验证回执；这些字段可由未来 P1/Orchestrator 收集原始日志后核实。

```yaml
task_id: '<任务ID>'
phase: '<阶段>'
role_id: '<本角色>'
soul_version: '<Soul版本/哈希>'
input_git_commit: '<实际受审基线，若适用>'
output_git_commit: '<实际新提交，若有>'
task_spec_sha256: '<实际规格哈希或UNVERIFIED>'
requested_harness: '<批准矩阵中的Harness>'
requested_model: '<批准矩阵中的模型>'
observed_model: 'UNVERIFIED # 除非有独立调用证据'
status: 'PASS | FAIL | QUESTION | BLOCKED | UNVERIFIED'
run_evidence: []
missing_evidence: []
```

## 证据列表最小字段

- `kind`: Git / Test / Build / CLI / Provider / Approval / Review / A2A / Other。
- `command_or_source`: 实际命令或来源，不写“已测”空话。
- `result`: 具体结果和退出码，或 NOT_RUN。
- `commit_sha`: 受测/受审 Git Commit。
- `artifact`: 报告、测试日志或原始事件路径。
- `hash`: 有条件则记录实际 SHA256；绝不生成无来源假值。
- `confidence`: VERIFIED / UNVERIFIED / NOT_RUN。

## Review判决

Spec/Quality: APPROVE / APPROVE_WITH_COMMENTS / REQUEST_CHANGES / NEEDS_SPECIALIST；疑义使用 QUESTION。
问题分类: BLOCKER / IMPORTANT / QUESTION / NIT / OPTIONAL / FYI。

## Gate判决

Tester A: GATE_A_PASS / FAIL / UNVERIFIED。
Tester B: GATE_B_PASS / FAIL / UNVERIFIED。
Arbitrator: PASS / REJECT / NEEDS_CLARIFICATION。
Pro-Audit: COMPLIANT / NON_COMPLIANT / UNVERIFIED / OBSERVATION。

**禁止混淆**：角色的专业判决 ≠ Hermes 已完成审批 ≠ 真实 Harness/模型调用证明 ≠ 自动允许部署。
