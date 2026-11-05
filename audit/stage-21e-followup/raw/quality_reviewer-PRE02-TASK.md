# 合成测试任务：quality_reviewer
task_id: STAGE21C-quality_reviewer
phase: 4
role_id: quality_reviewer
scope: 仅本目录 project 与列明的合成资料；不得访问生产项目、配置、密钥、其他角色目录或外机。
approved_intent: 用户在 Stage 21E 明确授权本次真实角色重测；规格冻结和阶段通过均为合成状态，不是生产批准。
task_spec: TASK_SPEC.md（相对本次指定的 WorkDir，即原有合成 project 目录）
spec_status: SIMULATED_FROZEN（仅测试）
task_spec_sha256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
git_commit: df21d132ab75c8560c12531b1cf2a6e1aa8a5d39（SYNTHETIC 本地合成基线）
role_assignment: 本次使用 Codex、请求模型 group/gpt-6-luna；通过指定辅助脚本单次调用。
soul_version: 1.1.0；本地 Soul SHA256 de7da8db6e94d862f5b83f9e4dd69f759bd2a3927c6853b062f0a64b44fd5207（重测前重新核对）
permission_intent: read_only
exact_assignment: 审查指定合成候选与 defect.diff，指出可证明的缺陷、路径行号、触发输入、影响和判决。不修改代码。

run_id: stage21e-quality_reviewer-001
