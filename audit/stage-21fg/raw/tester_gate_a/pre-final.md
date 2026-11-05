# PRE-01 审计记录 — stage21f-tester_gate_a-001

**审计身份**：p1-pro-audit（pro_audit）｜阶段：4.5｜审计类型：PRE-CHECK（只读）
**审计对象角色**：tester_gate_a｜Harness：codex｜Soul-Version：1.1.0
**性质声明**：本记录仅针对**用户明确授权的合成角色测试**，不代表生产 Gate 通过，不构成生产部署批准。

---

## 1. 基线核验

| 项目 | 期望值 | 实测值 | 结论 |
|---|---|---|---|
| task_id | STAGE21F-tester_gate_a | TASK.md L2 | VERIFIED |
| run_id | stage21f-tester_gate_a-001 | TASK.md L3 / BASELINE L2 | VERIFIED |
| phase / role | 4.5 / tester_gate_a | TASK.md L4-5 / BASELINE L3-4 / SOUL Phase 4.5 | VERIFIED |
| Git HEAD | 4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf | `git rev-parse HEAD` = 4e5a8073e1ea9203f7f66f0eeee6ae61e3a935bf | VERIFIED |
| 工作区状态 | 受测 tracked 文件无改动 | `git diff`/`git diff --cached` 均为空；`git status` 仅 `?? .input/`（输入材料，未跟踪） | VERIFIED |
| HEAD 树内容 | TASK_SPEC.md / test_examples.py / toy.py | `git ls-tree -r HEAD` 一致 | VERIFIED |

Commit 元数据：`4e5a807` / 21bao Local Agent / 2026-11-05 19:44:16 +0800 / "test: synthetic tester gate a baseline"。

## 2. 证据哈希核验（sha256sum 实测 vs BASELINE.json / TASK.md）

| 文件 | 期望 SHA256（BASELINE） | 实测 | 结论 |
|---|---|---|---|
| TASK_SPEC.md | 6b7a613f…ac45 | 6b7a613f…ac45 | MATCH |
| test_examples.py | 69dc8397…74a6 | 69dc8397…74a6 | MATCH |
| toy.py | 4277300d…bfde | 4277300d…bfde | MATCH |
| .input/AUTHORIZATION.md | 0a78a304…11e9 | 0a78a304…11e9 | MATCH |
| .input/SOUL.md | e2530a2b…e98a | e2530a2b…e98a | MATCH |
| .input/TASK.md | cac6f514…723f | cac6f514…723f | MATCH |
| .input/UPSTREAM_SYNTHETIC.md | e92f7538…451e | e92f7538…451e | MATCH |

TASK_SPEC SHA256（TASK.md L7）与 BASELINE `spec_sha256` 一致；Soul SHA256（TASK.md L8）与 BASELINE `soul_sha256` 及实测一致。**全部哈希一致，无篡改迹象。**

## 3. 角色 / 阶段 / 上游核验

- Soul 声明：`tester_gate_a`，Phase 4.5，Harness codex，Permission-Intent `test_files_only`，职责与派发一致。
- 上游 `.input/UPSTREAM_SYNTHETIC.md` 明确：Spec/Quality 审查为**模拟通过**，候选 Commit = 4e5a807…（与 HEAD 一致），且“缺陷有意保留”。→ 与 phase 4.5 前置要求形式吻合，但性质为 **SIMULATED**，非真实审查证据（已如实标注，不冒充真实 Gate）。
- 角色边界：允许新增测试文件/日志于 `test_output/`，允许产出 `_reports/` 下法定报告；不得改源码/已有测试/规格/.input。边界清晰。

## 4. 用户模型授权核验

| 维度 | 值 | 依据 | 结论 |
|---|---|---|---|
| 用户授权（approved） | group/gpt-6-luna | AUTHORIZATION.md L2-5 用户原文“Codex请求模型：group/gpt-6-luna”“这是用户先前明确指定的模型” | 已记录 |
| 请求（requested） | group/gpt-6-luna | TASK.md L10 / BASELINE `requested_model` | 与授权一致 |
| 观察（observed） | 尚未执行，无法核实服务端身份 | — | UNVERIFIED（留待 POST） |

说明：请求参数与授权一致；**服务端实际模型身份在 PRE 阶段不可验证**，不据此宣称已验证，交由 POST 依据 CLI Session/日志核对。

## 5. 交付目录 / 规格核验

- `_reports/`：存在且为空，TASK.md L12 明确授权为报告目录 → 合规。
- `test_output/`：存在且为空，授权新增测试/日志 → 合规。
- `TASK_SPEC.md`：存在，SHA 匹配；内容为 `count_done(items)` 合成规格（L1-4），声明“测试夹具/非生产规格”，与合成任务一致。
- 无 `_reports/`、`test_output/` 既有产出（不存在旧报告冒充本次 run 的风险）。
- 全目录仅含 9 个文件（3 受测 + 6 输入），无越界文件。

## 6. 发现

- **OBSERVATION（非阻断）**：`toy.py` L2 `return len(items)` 与 TASK_SPEC `只统计 True` 不符（缺陷），且 `test_examples.py` 现有用例预期会失败。此为 `UPSTREAM_SYNTHETIC.md` L2 声明的**有意保留缺陷**，属 Tester 本次应独立发现的测试对象，**不构成 PRE 合规阻断**。
- **OBSERVATION（非阻断）**：`.input/` 为未跟踪输入材料，工作区无 tracked 改动，符合预期。
- **UNVERIFIED（延后 POST）**：observed_model 服务端身份、实际执行/日志/退出码、报告真实产出。

## 7. 判定

- 基线 Commit、工作区状态、全部证据哈希、角色/阶段、用户模型授权（approved=requested）、允许报告目录、规格均核验通过。
- 无 `NON_COMPLIANT` 实质违规；唯一未决项为执行后证据（observed_model/日志/产出），属 POST 范畴，不影响启动前置。

**PRE: COMPLIANT**

（仅代表允许本次**合成角色测试**启动；生产 Gate 仍为 UNVERIFIED，不构成任何生产部署或 Gate 通过批准。）

---
*记录保留于本次 CLI 对话；未写入任何文件，未运行技术测试，未访问工作目录以外路径。*
