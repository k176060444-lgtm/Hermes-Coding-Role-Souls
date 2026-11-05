# 合成测试任务：arbitrator
task_id: STAGE21C-arbitrator
phase: 5.3
role_id: arbitrator
scope: 仅本目录 project 与列明的合成资料；不得访问生产项目、配置、密钥、其他角色目录或外机。
approved_intent: 用户在 Stage 21E 明确授权本次真实角色重测；规格冻结和阶段通过均为合成状态，不是生产批准。
task_spec: TASK_SPEC.md（相对本次指定的 WorkDir，即原有合成 project 目录）
spec_status: SIMULATED_FROZEN（仅测试）
task_spec_sha256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
git_commit: f987166becaff6e60e254694fd82ba064e001953（SYNTHETIC 本地合成基线；原始与最终候选相同）
upstream_evidence: ../CASE_SYNTHETIC.md（相对 WorkDir；合成案卷，盲审、整改、终测 UNVERIFIED）
role_assignment: 本次使用 Codex、请求模型 group/gpt-6-luna；通过指定辅助脚本单次调用。
soul_version: 1.1.0；本地 Soul SHA256 741f9388bdaf972bbffbdfdce41bb7e0f0a397b84b850cc16a9bbaed77f17f7f（重测前重新核对）
permission_intent: read_only
exact_assignment: 审阅指定同一候选快照及 CASE_SYNTHETIC.md，比较互相冲突的模拟意见，列出版本关系、真实可见依据和缺失证据；不能把缺失的盲审与测试写成已执行。

run_id: stage21e-arbitrator-001
