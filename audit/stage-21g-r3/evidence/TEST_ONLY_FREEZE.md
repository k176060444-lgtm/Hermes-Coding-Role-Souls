# TEST_ONLY 规格冻结记录（调度端）

- task_id: STAGE21G-INVENTORY
- 范围：仅本机 Inventory CSV CLI 联合演练；此记录不构成生产批准、生产 Gate、部署许可或真实外部盲审。
- 固定原 Git 基线：f2fafe432e0102d0249bfa2d6827a5f7c84a449e
- Planner run_id：stage21g-r3-planner-001；PRE 与 POST 的原始事件均已给出 COMPLIANT，调度端已核对原始文件变化与审计观察项。
- TASK_SPEC.md SHA256：dafc4a314bfb69c887929a3df12f6f76dee45d8686902659fc514352afe8258c
- USER_ALIGNMENT.md SHA256：3091b5b4917f63d2a6d474cad3ce4b927deb15ebf4579bc9e9536c038acd3d6d
- TDD_TASKS.md SHA256：b687d33b7fec780bad29adc793191c9c8d7149318e1fab05d84415a88a49ab16
- PLANNER_REPORT.md SHA256：cac988e7d060047c86a5b7e89ac978dbe73f30a72538a6854eb3ce629a12d48a
- 本次用户授权原文：.audit/planner-r3/USER_AUTHORIZATION.md。用户明确批准本地 TEST_ONLY 需求并授权调度端记录规格冻结；消息级 ID 和签名不可用。

## 对用户需求的核对

TASK_SPEC 第 10–20、51–64 和 67–77 行覆盖 `sku,delta` 两列、整数正负、同 SKU 累计、按 SKU 字典序、错误列数/空 SKU/非法整数明确报错、错误输入无伪成功、真实 unittest、标准库和本地范围。保留用户明确的禁止项。Planner 提出的可选边界由下文以本次实验最小实现选择确定，不改变用户已给定的核心业务规则。

## 本地实验接口和边界决策

1. CLI 使用一个本地 CSV 路径参数，输出 CSV 到标准输出；输入 UTF-8，首行表头为 `sku,delta`。成功输出表头同为 `sku,delta`，按 SKU 的 Python 字符串顺序输出总量。
2. 只有表头且无数据行是有效空汇总；空文件或错误表头是输入错误；数据中的空行按错误列数处理，不静默忽略。
3. SKU 原样保留作为汇总键；空字符串或仅由空白字符组成的 SKU 为错误。非空 SKU 不去除首尾空白，避免合并不同键。
4. `delta` 使用 Python 标准库整数解析；不能解析为整数则报错。任一错误以非零退出码结束、将诊断输出至 stderr，stdout 不产生表头、部分汇总或成功标记。先验证/汇总完整输入，再输出。
5. 不联网、不读取生产数据、不安装依赖；仅标准库。用 `python -m unittest` 实际执行测试。TDD 的 RED 是实际编写需求测试后观察失败；不为触发整改故意植入缺陷。

状态：**TEST_ONLY FROZEN**。本文件与以上 TASK_SPEC 哈希共同构成实验冻结内容；不得修改已冻结的 TASK_SPEC，若内容或哈希变化需停止并说明。实现阶段可以选择简单文件名，但不得更改以上可观察行为。
