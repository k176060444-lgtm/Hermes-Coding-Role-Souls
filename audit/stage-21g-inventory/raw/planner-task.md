# Stage 21G Planner: TEST_ONLY
task_id: STAGE21G-INVENTORY
run_id: stage21g-planner-001
phase: 0.2
role_id: planner
Harness: Codex
requested_model: group/gpt-6-luna
Soul SHA256: 6e00b632b38dee6094523efb1e3c6a02ee17198dd4c13fca43000fe6b1b50e0b
输入 Git Commit: f2fafe432e0102d0249bfa2d6827a5f7c84a449e
TASK_SPEC: NOT_YET_CREATED（本角色负责候选，尚未冻结）
请先读取 USER_BRIEF.md、TEST_ONLY_AUTHORIZATION.md 和本任务，真实审核当前项目及 Git 基线。完整说明用户目标、策略、流程、整体架构、验收及未决事项。仅为用户已明确授权的本地 TEST_ONLY 项目形成并自行写入工作区根目录 USER_ALIGNMENT.md、TASK_SPEC.md（候选未冻结）、TDD_TASKS.md、PLANNER_REPORT.md。TASK_SPEC 与需求一致，包括失败输入不能输出伪成功。用户授权此实验范围，不可冒充生产审批。
本次只写上述四份文档，不写业务代码，不改已有文件、.input 或 Git 元数据。不得联网、读生产数据、操作外机、装依赖、变配置、部署、访问无关项目或全局Skills。不要自行批准生产 Gate。区分请求模型与 observed_model=UNVERIFIED。实验后续由调度端审查规格、记录 TEST_ONLY 冻结，再派工兵；此过程不代表生产规格审批。
