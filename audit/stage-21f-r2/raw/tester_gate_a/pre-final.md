## PRE-01 合规核查记录

**身份**
- 审计角色：`p1-pro-audit`
- task_id：`STAGE21F-R2-tester_gate_a`
- run_id：`stage21f-r2-tester_gate_a-001`
- phase：`4.5`
- 受审角色：`tester_gate_a`
- 指定合成 Commit：`4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`
- 审计模式：只读；未写文件、未运行技术测试、未访问外部目录或外机

---

### 1. 输入与哈希核验

实际执行：`sha256sum -c -`，退出码 `0`，全部 `OK`。

| 文件 | 期望 SHA256 | 实际结果 |
|---|---|---|
| `TASK_SPEC.md` | `6b7a613f...47ac45` | 匹配 |
| `test_examples.py` | `69dc8397...f0174a6` | 匹配 |
| `toy.py` | `4277300d...82bfde` | 匹配 |
| `.input/AUTHORIZATION.md` | `22259740...ff8b4f` | 匹配 |
| `.input/SOUL.md` | `e2530a2b...094e98a` | 匹配 |
| `.input/TASK.md` | `732664d3...49f56ef` | 匹配 |
| `.input/UPSTREAM_SYNTHETIC.md` | `e92f7538...a261451e` | 匹配 |

与 `BASELINE.json.files_sha256` 全部一致；`TASK_SPEC.md` 和 `SOUL.md` 也与 `TASK.md`、`BASELINE.json` 中声明的规格/Soul 哈希一致。

---

### 2. Git 状态

实际执行结果：

- `git rev-parse HEAD` = `4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf`
- 与 `TASK.md`、`BASELINE.json`、`UPSTREAM_SYNTHETIC.md` 指定 Commit 完全一致，退出码 `0`
- `git log --oneline -10`：仅 1 个提交 `4e5a807 test: synthetic tester gate a baseline`
- `git ls-tree -r --name-only HEAD`：`TASK_SPEC.md`、`test_examples.py`、`toy.py`
- 已跟踪工作区干净；`git status` 仅显示 `.input/` 为未跟踪文件
- `git reflog --date=iso --all`：仅一次 clone 记录，时间为 `2026-11-05 22:39:59 +0800`
- `_reports/`、`test_output/` 均存在且为空

结论：HEAD 与指定合成 Commit 一致，受测代码/已有测试/规格未被修改；`.input/` 作为未跟踪合成案卷存在，不影响受测 Commit 哈希。

---

### 3. 角色、Harness 与模型

- `TASK.md`：Harness `Codex`，requested_model `group/gpt-6-luna`
- `SOUL.md`：Soul-Version `1.1.0`，Harness `codex`，Phase `4.5`，Permission-Intent `test_files_only`
- `AUTHORIZATION.md` 用户原话包含：`Codex请求模型：group/gpt-6-luna`
- `AUTHORIZATION.md` 另载 Stage 21G 原话：`OpenCode：沿用已批准的当前模型配置。不得临时换模型。`

核验结果：
- 角色阶段、Soul 版本、Harness 声明、权限意图与 `TASK.md` 一致。
- **authorized/requested model**：`group/gpt-6-luna`（Codex），与用户原话及任务派发一致。
- **observed_model**：`UNVERIFIED`。`AUTHORIZATION.md` 明确说明本机 OpenCode 配置为 `magpie/group/deepseek-v4.1-flash`，且该配置事实不能证明服务端模型；`TASK.md` 也要求无服务端绑定时标 `UNVERIFIED`。此项属于 POST 核验，不构成本次 PRE 的阻断。
- 未发现未经授权切换 Harness/模型的证据。

---

### 4. 用户授权与范围

`AUTHORIZATION.md` 载明：
- 续行会话中调度端提出用新 `run_id` 各补跑一次 Spec Reviewer 及 Tester，用户回复“执行”。
- 该授权仅限受控补测及符合条件的 Stage 21G，**不构成生产审批**。
- `TASK.md` 也明确：本任务是用户批准的合成演练，不是生产 Gate。

结论：合成演练的启动授权链在案卷内成立；但授权文本为引用文本，未附消息 ID/时间戳，生产级归属核验仍为 `UNVERIFIED`。

---

### 5. 报告写入范围

`TASK.md` 第 13 行授权：
- 报告仅写入 `_reports/`
- 测试文件及日志仅可写入 `test_output/`
- 禁止修改已有业务代码、已有测试、规格及 `.input/`

核验：
- `_reports/`、`test_output/` 均存在，当前为空，不存在旧报告冒充本次输出。
- 受测文件哈希与基线一致，未发现已有文件被修改。
- 未发现越界写入痕迹。

---

### 6. 上游合成案卷

`UPSTREAM_SYNTHETIC.md` 明示：
- Spec Review、Quality Review 为“模拟通过”，不是实际审查或批准。
- 缺陷有意保留，供测试官独立发现。
- 合成候选 Commit 与本次指定 Commit 一致。

结论：该上游材料仅可作为**合成演练输入**；生产 Gate 上游审批仍为 `UNVERIFIED`。本次 PRE 不将其冒充真实审批。

---

### 7. 发现与判定

**阻断性问题：无。**

**非阻断观察项：**
1. `observed_model` 无服务端绑定证据，POST 必须继续标 `UNVERIFIED`，不得写成 PASS。
2. 用户授权为案卷内引用文本，无消息 ID/时间戳；生产级授权归属为 `UNVERIFIED`。
3. 上游 Phase 3/4 仅为模拟通过，生产 Gate 状态保持 `UNVERIFIED`。
4. 未提供候选备用模型；合成案卷未强制要求，记为 `OBSERVATION`。
5. 无独立 Runner 调用台账；“无异常重试”仅基于当前工作区无旧报告、无测试输出、reflog 仅一次 clone 的证据，不能扩展为生产级证明。

---

## PRE-01 判定

**PRE: COMPLIANT**

仅表示：该**合成** `tester_gate_a` 角色在给定合成案卷下满足启动前的授权、角色、哈希、写入范围和 Git 基线条件，可以启动本次合成演练。

**不构成生产 Gate 审批。** 启动后仍须执行 POST-01，并如实记录 `observed_model` 为 `UNVERIFIED`（除非取得服务端模型证据）。
