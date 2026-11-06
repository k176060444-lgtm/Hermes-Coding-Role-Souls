# PRE 审计记录 — stage21g-r6-tester-a-001

## 0. 身份、范围与限制

| 项目 | 内容 |
|---|---|
| 审计角色 | `p1-pro-audit`（OpenCode，Soul 1.1.1，read_only） |
| 受审运行 | `stage21g-r6-tester-a-001` |
| 受审角色 / 阶段 | `tester_gate_a` / Phase 4.5（Tester Gate A） |
| task_id | `STAGE21G-INVENTORY` |
| 受审 Harness | Codex（派发声明） |
| requested_model | `group/gpt-6-luna` |
| observed_model | **UNVERIFIED**（无独立服务端绑定证据；不以本审计进程模型冒充） |
| 受审 Soul 副本 | `.audit/tester-a-r6/SOUL.md`，Soul-Version `1.1.0`，Permission-Intent `test_files_only` |
| 本次动作 | 唯一一次 PRE；未执行任何项目代码或测试；未写文件；未联网；未读取授权清单外材料 |

说明：本审计进程自身模型为 `magpie/group/deepseek-v4.1-flash`，该值不构成 Tester 角色模型身份证据。

---

## 1. 固定基线与输入完整性

实际执行的只读命令：`git rev-parse HEAD`、`git status --porcelain -uall`、`git diff --stat`、`git ls-tree`、`git hash-object`、`git worktree list --porcelain`、`sha256sum`、`ls/find tests_gate_a`。上述 Git/hash 命令退出码均为 0（`ls` PRE 文件不存在时退出码 2，属预期）。

| 检查项 | 期望值 | 实测证据 | 判定 |
|---|---|---|---|
| Git HEAD | `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13` | `git rev-parse HEAD` 完全一致；`git worktree list` 显示 tester worktree detached 于同一 SHA | **VERIFIED** |
| HEAD 父提交 | `f2fafe432e0102d0249bfa2d6827a5f7c84a449e`（FREEZE 基线） | `git rev-parse HEAD^` 一致，且为 HEAD 祖先 | **VERIFIED** |
| TASK_SPEC SHA256 | `dafc4a31…8258c` | 实测 `dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c` | **VERIFIED** |
| TEST_ONLY_FREEZE SHA256 | `bb1fe989…ce63c` | 实测 `bb1fe989ef24ff0b6b7a4d202ad24ea6ea01dedfc09e147133f15dde184ce63c` | **VERIFIED** |
| Tester Soul SHA256 | `e2530a2b…e98a` | 实测 `e2530a2b5c8ca0cb679c96777cb9b83db7e0edb7a0e6f8fcb64bea191094e98a`，与 TASK/BASELINE 一致 | **VERIFIED** |
| TASK.md SHA256 | BASELINE `e9d9b307…` | 实测一致 | **VERIFIED** |
| USER_AUTHORIZATION.md SHA256 | BASELINE `76d9db1c…` | 实测一致 | **VERIFIED** |
| MERGE.json SHA256 | BASELINE `4216ed10…` | 实测一致 | **VERIFIED** |
| SPEC_REVIEW_REPORT.md SHA256 | MERGE `6a0daabd…` | 实测 `6a0daabd9458b870eb3c58722b6f7e48ccb7ff28f884acd094dd20483a058aa3` | **VERIFIED** |
| QUALITY_REVIEW_REPORT.md SHA256 | MERGE `e26408f0…` | 实测 `e26408f0a6a2cb22b9cb71caab812ebc2e784637fa1e5db39d1f0ae9ce81fd7d` | **VERIFIED** |
| 受审代码/测试未被改动 | `inventory.py`、`test_inventory.py` 与 HEAD 一致 | `git diff --stat` 为空；`git hash-object` 分别得到 `ff7f749c…`、`1c0c4e55…`，与 `git ls-tree HEAD` 完全一致 | **VERIFIED** |
| 冻结文件与 HEAD 一致 | TASK_SPEC/FREEZE 无工作树改动 | `git hash-object` 得到 `49d28f27…`、`5904fd12…`，与 HEAD blob 一致；`git diff` 为空 | **VERIFIED** |
| 工作区干净度 | 仅审计材料未跟踪 | `git status --porcelain -uall` 仅列出 `.audit/tester-a-r6/*` 的 8 个未跟踪材料；无代码/测试/规格改动 | **VERIFIED** |
| 独立 Tester worktree | 与 Spec/主 worktree 分离 | 当前根 `[USER_HOME]\Stage21G-R6\tester`；`.git` 为 `gitdir: …/worktrees/tester`；`git worktree list` 显示 main、spec、tester 三处分立 | **VERIFIED** |
| 测试唯一写入目录 | 仅 `tests_gate_a/` | 目录存在，仅含空 `tests_gate_a/tmp/`；无任何测试文件、报告、日志或缓存 | **VERIFIED** |
| PRE 原始事件/回执 | 本次审计时尚不存在属正常 | `.audit/tester-a-r6/PRE.jsonl`、`PRE_RECEIPT.json` 均不存在（`ls` 退出码 2） | **NOT_YET / 预期** |
| `pre_prompt_sha256`、Codex helper、Codex 会话扫描 | BASELINE 自报 | 授权读取范围不允许读取 `PRE_PROMPT.txt`、helper 及其他目录；未独立重算 | **UNVERIFIED（范围外）** |

`PRE_PROMPT.txt` 仅被目录列表见到，未读取其内容；故 BASELINE 中的 `pre_prompt_sha256` 未核对，不作通过断言。

---

## 2. PRE-CHECK 逐项判定

### 2.1 角色、阶段与调用顺序

- Tester Gate A 为 Phase 4.5，位于 Spec Review（Phase 3）与 Quality Review（Phase 4）之后。
- 两份正式报告均指向同一 Commit `a1d4a578…`，结论均为 `APPROVE_WITH_COMMENTS`，未见 BLOCKER/IMPORTANT 实质阻断。
- **判定：VERIFIED（官方汇合案卷层）。**

### 2.2 Soul 版本、职责与权限意图

- `.audit/tester-a-r6/SOUL.md`：`Soul-Version 1.1.0`、`Harness: codex`、`Phase: 4.5`、`Permission-Intent: test_files_only`；角色 `tester_gate_a` 的职责、法定交付物和禁止项与 TASK.md 第 20–31 行一致。
- Soul 文件 SHA256 与派发值、BASELINE 完全一致。
- **判定：Soul 副本与派发值 VERIFIED；运行时实际注入 UNVERIFIED（无独立运行时证据）。**

### 2.3 输入完整性

已具备：TASK.md、USER_AUTHORIZATION.md、SOUL.md、MERGE.json、BASELINE.json、两份正式报告、当前 worktree 的 TASK_SPEC.md 与 TEST_ONLY_FREEZE.md；固定 Commit 与对应代码/测试存在。

PRE 原始事件与回执按用户说明在 PRE 结束后由调度端生成，因此审计时缺失属正常；但它们是 Tester 角色启动前必须存在的输入。

- **判定：输入齐全（当前阶段）VERIFIED；PRE 回执为调度端待办，不作为本轮失败。**

### 2.4 Harness 与模型矩阵

- TASK.md 与 USER_AUTHORIZATION.md 均声明 Tester 使用 Codex，requested_model `group/gpt-6-luna`；BASELINE 同值。
- 未发现 Tester 侧未经授权切换模型的证据；observed_model 无独立服务端绑定证据，标 **UNVERIFIED**。
- Spec Reviewer 报告自述其自身模型为 `magpie/group/deepseek-v4.1-flash`，这是该审查角色的派发值，不是 Tester 的模型切换，不构成本轮 Tester 违规。
- **判定：声明层 VERIFIED；实际服务端身份 UNVERIFIED。**

### 2.5 Git 基线、Spec 版本与审查引用一致性

- main/spec/tester 三处 worktree 均指向 `a1d4a578f9334bfcda8004d25a4a43dfef7ebf13`。
- 两份报告、MERGE.json、BASELINE.json 引用的 HEAD、TASK_SPEC SHA、FREEZE SHA 均一致。
- 工作树无 tracked 文件差异；TASK_SPEC/FREEZE 与 HEAD blob 一致。
- **判定：VERIFIED。**

### 2.6 状态不明重试、未处理违规与用户批准

- 当前 worktree 无先前 Tester A 的测试、报告或 PRE 回执产物；BASELINE 记录 `record_absent=true`、`tests_absent=true`。
- USER_AUTHORIZATION.md 明确“允许启动一次 Tester Gate A”“一次 PRE、一次 Tester、一次 POST”“本次授权完整，可以执行”。
- 消息级 ID、签名、时间戳在授权文件中自述 `UNAVAILABLE`，未伪造；**授权文档层 VERIFIED，消息来源层 UNVERIFIED**。
- **判定：VERIFIED（文档层）；未发现未知重试或未处理违规。**

---

## 3. 双审正式案卷核对

| 核对项 | Spec Reviewer | Quality Reviewer | 判定 |
|---|---|---|---|
| run_id | `stage21g-r6-spec-reviewer-001` | `stage21g-r3-quality-reviewer-001` | MERGE 记录一致，**VERIFIED** |
| 受审 Commit | `a1d4a578…` | `a1d4a578…` | 同一 Commit，**VERIFIED** |
| 技术结论 | `APPROVE_WITH_COMMENTS`；含逐条规格矩阵、BLOCKER 无、Q1/NIT-1/FYI-1 | `APPROVE_WITH_COMMENTS`；含具体 OPTIONAL：无效 UTF-8 未捕获 `UnicodeDecodeError` | 结论真实、内容互异，**VERIFIED** |
| 报告 SHA256 | `6a0daabd…`，与 MERGE 记录一致 | `e26408f0…`，与 MERGE 记录一致 | **VERIFIED** |
| PRE / POST 判决 | MERGE 记录 `pre=COMPLIANT`、`post=COMPLIANT` | MERGE 记录 `pre=COMPLIANT`、`post=COMPLIANT` | **记录层 VERIFIED；原始事件 SHA256 因授权读取范围外无法独立重算，标 UNVERIFIED（非阻断）** |
| 独立性 | 报告自述未读取 Quality 私人材料 | 报告自述未读取 Spec R6 结果 | MERGE 声明“仅为现有可得事件范围内核验”，原始事件层 **UNVERIFIED（非阻断）** |
| 时序 | run_id 为 r6 | run_id 为 r3 | MERGE 明确“不在本轮同时执行”；按先后产生理解，**不断言同时运行**；精确时间戳未独立核验 |

两份报告不是复制品：Spec 报告给出逐条规格/代码行号矩阵及边界决策，Quality 报告给出独立的无效 UTF-8 静态推断。技术结论与哈希均可与本目录文件复核。生产审批未被声称，MERGE 与两份报告均明确 TEST_ONLY、非生产批准。

---

## 4. 用户授权与写入边界

| 检查项 | 证据 | 判定 |
|---|---|---|
| 一次性授权 | USER_AUTHORIZATION.md：允许启动一次 Tester Gate A；一次 PRE、一次 Tester、一次 POST | **VERIFIED（文档层）** |
| 模型请求 | `group/gpt-6-luna`，与 TASK、BASELINE 一致 | **VERIFIED（请求参数层）** |
| 工作目录 | 当前独立 Tester worktree，detached HEAD `a1d4a578…`；非 Spec worktree | **VERIFIED** |
| 唯一写入目录 | TASK.md 第 23–28 行限定 `tests_gate_a/`；当前仅有该目录及空 `tmp/`，无越界产物 | **VERIFIED** |
| `tests_gate_a/tmp` | 用户明确其为测试内临时目录，无需额外授权 | **可接受，VERIFIED** |
| 禁止修改业务代码/冻结规格/现有测试 | TASK.md 第 30 行；当前 tracked diff 为空，HEAD blob 与工作树一致 | **VERIFIED（开工前状态）** |
| 不联网、不使用包管理器、不部署 | TASK.md 第 30 行；本轮未执行任何项目命令 | **VERIFIED（范围声明）** |
| 消息级签名/ID/时间戳 | USER_AUTHORIZATION.md 自述不可得 | **UNAVAILABLE / UNVERIFIED，未虚构** |

另注：`TASK_SPEC.md` 第 3 行仍写“候选，未冻结”，而 `TEST_ONLY_FREEZE.md` 第 25 行写“TEST_ONLY FROZEN”，且 FREEZE 第 7 行记录的 TASK_SPEC SHA 与实际一致。Spec 报告已将其列为 Q1 非阻断措辞问题；本轮沿用：**内容哈希冻结有效，状态行文字为陈旧描述，不构成阻断**。

---

## 5. 未验证 / 未运行事项（如实披露）

| 事项 | 状态 | 原因 |
|---|---|---|
| 服务端 observed_model | **UNVERIFIED** | 无独立服务端绑定证据；请求参数不等于身份证据 |
| 运行时实际注入的 Tester Soul | **UNVERIFIED** | 仅能核对副本 SHA，无法独立证明运行时加载 |
| 用户授权消息 ID/签名/时间戳 | **UNAVAILABLE / UNVERIFIED** | 授权文件自述不可得 |
| Reviewer 原始 PRE/POST 事件哈希与独立交叉读取 | **UNVERIFIED** | 原始事件不在本目录；授权禁止读取其他目录/私人材料；仅采用官方 MERGE 记录 |
| Codex helper SHA、Codex 会话扫描、PRE_PROMPT 哈希 | **UNVERIFIED** | 超出本轮授权读取范围 |
| Tester A 实际测试执行、测试数量、退出码、RED/GREEN | **NOT_RUN** | 本轮仅 PRE，不执行测试 |
| Tester A 考卷/证据/Gate A 报告 | **NOT_YET** | 应由 Tester 角色在 `tests_gate_a/` 生成，PRE 阶段尚不存在 |
| 本次运行的 PRE.jsonl / PRE_RECEIPT.json | **NOT_YET** | PRE 结束后由调度端生成；角色启动前必须完成 |
| POST 审计 | **NOT_RUN** | 用户仅要求一次 PRE；POST 属后续角色任务 |

---

## 6. 观察项与最小后续动作

1. **OBSERVATION — PRE 回执待生成**：调度端须在 Tester 角色启动前生成 `.audit/tester-a-r6/PRE.jsonl` 与 `PRE_RECEIPT.json`；Tester 启动时应先读取并核对。缺失时不得启动角色。
2. **OBSERVATION — TASK_SPEC 状态行措辞**：候选/未冻结字样与 FREEZE 的冻结状态不一致；以 FREEZE 及哈希为准，非阻断。
3. **OBSERVATION — 双审原始事件层不可独立重算**：MERGE 已给出报告哈希与 PRE/POST 判决，但原始事件哈希不在授权读取范围；记录层有效，原始层保留 UNVERIFIED。
4. **OBSERVATION — 双审时序**：按官方 MERGE 与 run_id 记录为先后产生，未发现同时运行证据，也未作同时运行断言。
5. **边界提醒**：`tests_gate_a/tmp/` 当前为空，允许 Tester 在该子目录内创建临时夹具；除此之外不得产生授权目录外缓存、测试或报告；不得修改 `inventory.py`、`test_inventory.py`、冻结规格或既有审计材料。

---

## 7. 唯一最终结论

**PRE: COMPLIANT**

理由：固定 HEAD、TASK_SPEC SHA、FREEZE SHA、Tester Soul SHA、两份正式报告及其 MERGE 哈希、同一 Commit 的双审结论、一次性用户授权、requested_model `group/gpt-6-luna`、独立 Tester worktree 与 `tests_gate_a/` 唯一写入边界，均已在本轮授权证据范围内核实；未发现 BLOCKER 级偏离。observed_model、运行时 Soul 注入、授权消息签名/ID、Reviewer 原始事件哈希等无法独立核验者均已如实标为 UNVERIFIED，未虚构生产审批。

**启动前置条件**：调度端须先生成本次 `PRE.jsonl` 与 `PRE_RECEIPT.json`；Tester 角色启动时须读取并核对。未满足前不得启动 Tester 角色。本结论不构成生产 Gate 批准或部署许可。