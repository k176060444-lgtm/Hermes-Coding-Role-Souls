# Stage 21F 合成角色任务
task_id: STAGE21F-tester_gate_a
run_id: stage21f-tester_gate_a-001
phase: 4.5
role_id: tester_gate_a
Git Commit: 4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf
TASK_SPEC SHA256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
Soul SHA256: e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a
用户授权来源：用户原文“Codex请求模型：group/gpt-6-luna”“这是用户先前明确指定的模型”；本次用户正式授权21F三角色定向重做及Spec Reviewer负向补测。
请求模型：group/gpt-6-luna；此值为请求/现有配置，不声称已独立验证服务端模型。
项目与资料：只读取当前工作目录内的源码、TASK_SPEC.md、.input/内列明文件及Git元数据。禁止读取父目录、其他项目、全局Skills/Soul、配置、密钥或外机。
允许交付：_reports/ 目录为本次用户明确授权的报告目录，可以创建角色法定报告；不得以只读为由自行放弃报告。除报告目录外，仅Tester可在test_output/新增测试文件和测试日志；不修改源码、已有测试、规格和.input/。
授权性质：仅合成实验；冻结和上游阶段均为SIMULATED，不代表真实生产Gate审批。
任务：先核对.input/UPSTREAM_SYNTHETIC.md，设计并实际执行准入测试。真实命令、退出码和结果须记录；缺陷存在时如实报FAIL，不自行修复。自行生成 _reports/TEST_A_CASES.md、_reports/TEST_A_EVIDENCE.md、_reports/GATE_A_REPORT.md，仅可在test_output/新增测试与日志。
