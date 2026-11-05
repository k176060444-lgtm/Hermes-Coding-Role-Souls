# PRE-01 合规核查记录（只读）

## 0. 身份与范围

| 项 | 值 |
|---|---|
| 审计角色 | p1-pro-audit（Soul 1.1.1，Permission-Intent: read_only） |
| 受审 run_id | stage21f-r2-p1-spec-reviewer-001 |
| task_id | STAGE21F-R2-p1-spec-reviewer |
| phase / role_id | 3 / p1-spec-reviewer |
| 本次范围 | 仅 PRE-01；不写文件、不跑技术测试、不访问外部目录/外机/全局配置 |
| 性质 | 用户授权的合成负向夹具（无 Git/Commit），**非生产 Gate** |

## 1. 证据清单与实际核对

实际执行命令与退出码：

- `sha256sum TASK_SPEC.md toy.py test_examples.py .input/{TASK,AUTHORIZATION,SOUL,BASELINE,PRE_PROMPT}` → 退出码 0
- `git rev-parse --is-inside-work-tree` → 退出码 **128**（`fatal: not a git repository`）
- `git status --porcelain` / `git log --oneline -5` → 退出码 **128**（同上）
- `ls -la`（当前目录 / `_reports`）→ 退出码 0

哈希对账（期望值取自 `.input/BASELINE.json` 与 `.input/TASK.md`）：

| 文件 | 期望 SHA256 | 实测 SHA256 | 结论 |
|---|---|---|---|
| TASK_SPEC.md | 6b7a613f…47ac45 | 6b7a613f…47ac45 | VERIFIED |
| toy.py | 80fca634…c0ffe0 | 80fca634…c0ffe0 | VERIFIED |
| test_examples.py | 69dc8397…f0174a6 | 69dc8397…f0174a6 | VERIFIED |
| .input/AUTHORIZATION.md | 22259740…fcff8b4f | 22259740…fcff8b4f | VERIFIED |
| .input/SOUL.md | 5226a65f…bf4ff4d | 5226a65f…bf4ff4d | VERIFIED |
| .input/TASK.md | 0253d0f0…b092586 | 0253d0f0…b092586 | VERIFIED |

规格哈希一致性：`TASK.md:9`、`BASELINE.spec_sha256`、`BASELINE.files_sha256["TASK_SPEC.md"]` 三者均为 `6b7a613f…47ac45`，与实测一致。
Soul 哈希一致性：`TASK.md:10`、`BASELINE.soul_sha256`、`BASELINE.files_sha256[".input/SOUL.md"]` 均为 `5226a65f…bf4ff4d`，与实测一致。

## 2. 六项 PRE-CHECK 判定

| # | 检查项 | 判定 | 依据 |
|---|---|---|---|
| 1 | 角色/阶段关系、调用顺序、上游 Gate | VERIFIED（限合成范围） | TASK.md 与 SOUL 均为 Phase 3 / p1-spec-reviewer；本任务是用户批准的受控补测。生产性 Phase 3/4 同 Commit 并行条件不成立，因本夹具无 Commit，仅作为缺证据处理测试 |
| 2 | 获批准 Soul 版本、职责与读写意图 | VERIFIED | SOUL-Version 1.1.0、Harness opencode、Permission-Intent read_only；哈希与基线一致；职责为只读规格审查，未越权 |
| 3 | 输入齐全度 | VERIFIED（按负向夹具设计） | 用户要求、TASK_SPEC、Soul、工作目录、专属材料（toy.py/test_examples.py）均在；**Git Commit 故意缺失**，已在 TASK.md:8 / BASELINE.commit=null / negative_case=true 明确披露，未伪造 |
| 4 | Harness/模型与批准矩阵 | requested 一致；observed UNVERIFIED | Harness=OpenCode 一致；requested_model=`magpie/group/deepseek-v4.1-flash` 与 AUTHORIZATION 记录的 OpenCode 当前配置一致。**服务端模型身份无法核实**（未访问全局配置/外机，禁止越界），不得声称已验证 |
| 5 | Git 基线与 Spec 版本一致性 | Spec VERIFIED；Git **NOT_RUN/缺失（设计内）** | Spec 版本三处一致；`git rev-parse` 退出码 128，确认非 Git 仓库，与“原有无 Git 负向夹具”声明相符；不得视为已批准基线 |
| 6 | 不明状态调用/重试/未处理违规/缺失用户批准 | VERIFIED | 案卷未显示重复调用、超时重试或未处理违规；用户授权原文与“执行”回复记录在 AUTHORIZATION.md |

## 3. 用户授权原文核对

AUTHORIZATION.md 明确记录：

- Stage 21F 原文：“Codex请求模型：group/gpt-6-luna”“通过当前OpenCode原生Agent：p1-spec-reviewer”
- Stage 21G 原文：“OpenCode：沿用已批准的当前模型配置。不得临时换模型。”
- Stage 21F 原文：“PRE不通过不启动对应角色。角色启动后无论成功失败都执行POST。”
- 续行会话：用户回复“执行”，仅授权受控补测与符合条件的 21G，**不构成生产审批**。

结论：授权原文与范围 VERIFIED。`group/gpt-6-luna` 属 21F Codex 语境；本 run 使用 OpenCode + 已记录当前配置 `deepseek-v4.1-flash`，与 21G“沿用已批准 OpenCode 配置”相符。此点作为 OBSERVATION 记录，不构成阻断。

## 4. 报告写入范围

TASK.md:13 明确：报告仅可写入 `_reports/`；禁止改动业务代码、已有测试、规格、`.input/` 及其他文件。实测 `_reports/` 存在且为空，符合授权范围。写入范围 VERIFIED。

## 5. 必须保留的限制与警示

1. `observed_model`、服务端模型身份、config.json SHA256 均 **UNVERIFIED**（未越界读取全局配置/外机），POST 阶段不得将其写成已验证。
2. Git/Commit 缺失是**负向夹具设计**，不得伪造基线、不得把缺证据当作批准；角色若需 Commit 基线，应输出 `UNVERIFIED`/`QUESTION`。
3. TASK_SPEC 自述为合成夹具，“模拟冻结/批准仅为测试输入”，不代表真实生产审批。
4. 本次 PRE 通过**仅授权启动该合成缺证据处理测试**，不构成生产 Gate 审批，也不代表 Phase 3 生产审查合规。

## 6. 最终判定

**PRE: COMPLIANT**

（限定范围：仅允许启动本次“缺证据处理”合成测试；启动后必须按 Stage 21F 执行 POST，且不得将缺失 Git/Commit 或未核实的模型身份表述为已批准。）
