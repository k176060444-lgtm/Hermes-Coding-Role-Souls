# Pro-Audit 每次角色/阶段合规记录模板

每次独立调用记录至少一份 PRE 与一份 POST。未来编排如何调度此角色不在当前角色配置部署范围内。

```yaml
task_id: '<ID>'
phase: '<当前阶段>'
target_role_id: '<被检查角色>'
target_run_id: '<如存在；否则UNVERIFIED>'
check_point: 'PRE | POST | JOIN | GATE'
checked_at: '<实际时间或UNVERIFIED>'
approved_matrix_sha256: '<如已批准>'
soul_sha256: '<实际角色Soul>'
task_spec_sha256: '<实际规格哈希>'
input_commit_sha: '<受检commit>'
output_commit_sha: '<产出commit或无>'
requested_harness: '<批准值>'
requested_model: '<批准值>'
observed_harness: '<实际证据或UNVERIFIED>'
observed_model: '<实际证据或UNVERIFIED>'
cli_session_id: '<真实ID或UNVERIFIED>'
invocation_count: '<可证实次数或UNVERIFIED>'
input_check: 'COMPLIANT | NON_COMPLIANT | UNVERIFIED'
output_check: 'COMPLIANT | NON_COMPLIANT | UNVERIFIED'
permission_scope_check: 'COMPLIANT | NON_COMPLIANT | UNVERIFIED'
evidence_check: 'COMPLIANT | NON_COMPLIANT | UNVERIFIED'
findings:
  - {id: '<问题ID>', severity: '<影响>', evidence: '<证据路径或文件:行号>'}
result: 'COMPLIANT | NON_COMPLIANT | UNVERIFIED | OBSERVATION'
requires_next_action: '<事实说明，不自行批准>'
```

关键模型/证据无法核实时必须给 UNVERIFIED；无关排版或风格改进用 OBSERVATION。Pro-Audit 审查过程合规，不判断业务代码好坏。
