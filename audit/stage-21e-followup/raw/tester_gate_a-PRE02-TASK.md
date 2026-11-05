# 合成测试任务：tester_gate_a
task_id: STAGE21C-tester_gate_a
phase: 4.5
role_id: tester_gate_a
scope: 仅本目录 project 与列明的合成资料；不得访问生产项目、配置、密钥、其他角色目录或外机。
approved_intent: 用户在 Stage 21E 明确授权本次真实角色重测；规格冻结和阶段通过均为合成状态，不是生产批准。
task_spec: TASK_SPEC.md（相对本次指定的 WorkDir，即原有合成 project 目录）
spec_status: SIMULATED_FROZEN（仅测试）
task_spec_sha256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
git_commit: 4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf（SYNTHETIC 本地合成基线）
upstream_evidence: ../UPSTREAM_SYNTHETIC.md（相对 WorkDir；合成材料，不代表真实审查）
role_assignment: 本次使用 Codex、请求模型 group/gpt-6-luna；通过指定辅助脚本单次调用。
soul_version: 1.1.0；本地 Soul SHA256 e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a（重测前重新核对）
permission_intent: test_files_only
exact_assignment: 核对模拟规格、候选基线与模拟上游状态。独立设计并实际运行准入测试，仅允许新增 project/test_output/ 中的测试文件及报告，不修改业务代码、规格或已有测试；如运行受限应报告 NOT_RUN。

run_id: stage21e-tester_gate_a-001
