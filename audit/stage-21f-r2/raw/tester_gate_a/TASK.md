# Stage 21F 已获授权补测
task_id: STAGE21F-R2-tester_gate_a
run_id: stage21f-r2-tester_gate_a-001
phase: 4.5
role_id: tester_gate_a
Harness: Codex
requested_model: group/gpt-6-luna
Git Commit: 4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf
TASK_SPEC SHA256: 6b7a613fc03e9f3c7df98ab6a240957bf61ab149ec73e4181628a9a22947ac45
Soul SHA256: e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a
用户授权来源与模型证据：.input/AUTHORIZATION.md。observed_model 无服务端绑定时标UNVERIFIED。
只读取工作目录内源码、TASK_SPEC、.input案卷和Git元数据；禁止访问父目录、其他项目、全局配置/Skills/Soul、密钥和外机。该任务是用户批准的合成演练，不是生产Gate。
报告只能写入明确授权的 _reports/；除此之外，仅可在 test_output/ 创建测试文件及日志；禁止修改已有业务代码、已有测试、规格、.input/。
先读取.input/UPSTREAM_SYNTHETIC.md，设计并真正运行准入测试，如实记录命令、退出码、原始输出和缺陷。自行生成 _reports/TEST_A_CASES.md、TEST_A_EVIDENCE.md、GATE_A_REPORT.md。仅在 test_output/ 创建新增测试与日志；运行pytest时使用 -p no:cacheprovider 或等效方式，不得在允许目录外生成缓存。不得修改业务源码。
