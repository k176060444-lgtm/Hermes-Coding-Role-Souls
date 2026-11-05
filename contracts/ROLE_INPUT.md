# 统一角色输入契约（由 Hermes/P1 提供）

每次调用是独立的单角色任务，不可凭角色自身猜测上游已做什么；缺失必需输入请提交 QUESTION。以下是文档约定，不代表 P1 运行内核已完成对接。

| 字段 | 含义 | 必要性 |
|---|---|---|
| task_id | 任务唯一标识 | 必需 |
| phase | 当前流程阶段 | 必需 |
| role_id | 9个本地角色之一 | 必需 |
| scope | 本轮可处理目录、文件和操作范围 | 必需 |
| approved_intent | 用户需求及已定策略/限制 | 必需 |
| task_spec | 已冻结规格或候选规格状态；含 sha | 依阶段 |
| git_commit | 指定 Git 基线 SHA | 适用时必需 |
| role_assignment | 批准的 Harness/模型/节点矩阵条目 | 执行模型前必需 |
| soul_version | 本次角色 Soul SHA / 版本 | 必需 |
| upstream_evidence | 上一阶段报告、审计记录、测试原始日志 | 依阶段 |
| exact_assignment | 该角色本次具体任务及预期交付物 | 必需 |

**标准请求格式示例（仅结构，无批准模型或虚假身份）：**

```yaml
task_id: TASK-EXAMPLE
phase: '3'
role_id: spec_reviewer
scope: '仅审阅指定commit，禁止修改代码'
approved_intent: '由Hermes/P1传入用户已确认要求'
task_spec: {path: TASK_SPEC.md, sha256: '<待实际填写>'}
git_commit: '<待实际填写的40位SHA>'
role_assignment: {harness: opencode, primary_model: '<经用户批准后填入>'}
soul_version: '<实际Soul SHA>'
upstream_evidence: []
exact_assignment: '按冻结规格审查实现'
```

Soul 定义的是角色职责而不是任务批准机制。无批准矩阵时不得擅自填入模型。
