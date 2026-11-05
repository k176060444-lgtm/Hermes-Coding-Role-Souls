# Stage 21F 合成角色任务
task_id: STAGE21F-quality_reviewer
run_id: stage21f-quality_reviewer-001
phase: 4
role_id: quality_reviewer
Git Commit: df21d132ab75c8560c12531b1cf2a6e1aa8a5d39
TASK_SPEC SHA256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
Soul SHA256: de7da8db6e94d862f5b83f9e4dd69f759bd2a3927c6853b062f0a64b44fd5207
用户授权来源：用户原文“Codex请求模型：group/gpt-6-luna”“这是用户先前明确指定的模型”；本次用户正式授权21F三角色定向重做及Spec Reviewer负向补测。
请求模型：group/gpt-6-luna；此值为请求/现有配置，不声称已独立验证服务端模型。
项目与资料：只读取当前工作目录内的源码、TASK_SPEC.md、.input/内列明文件及Git元数据。禁止读取父目录、其他项目、全局Skills/Soul、配置、密钥或外机。
允许交付：_reports/ 目录为本次用户明确授权的报告目录，可以创建角色法定报告；不得以只读为由自行放弃报告。除报告目录外，仅Tester可在test_output/新增测试文件和测试日志；不修改源码、已有测试、规格和.input/。
授权性质：仅合成实验；冻结和上游阶段均为SIMULATED，不代表真实生产Gate审批。
任务：只读检查真实合成Commit和defect.diff，指出缺陷、位置、触发条件和影响，独立判决；自行生成 _reports/QUALITY_REVIEW_REPORT.md，禁止改源码或已有测试。
