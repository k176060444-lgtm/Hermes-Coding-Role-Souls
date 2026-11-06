# USER_AUTHORIZATION — 21G-R4（原文节选）

来源：当前 QQ 私聊中用户的 Stage 21G-R4 消息；消息级 ID、签名和精确时间戳在当前上下文不可用。以下为原文节选，不冒充完整原文或独立身份签名：

> 【21bao Stage 21G-R4：修复Spec PRE事实误判，续行双审与联合实战】
> 【本任务仅1段，收到即全部收齐，可执行】
>
> 本次是用户新授权的TEST_ONLY续行，
> 不是自动重试，不是生产审批。
>
> 不得重新运行Planner或Worker。
> 不得重新创建项目。
> 不得重新生成代码或冻结规格。
> 不得修改既有Commit。
>
> 新run_id：
> stage21g-r4-spec-reviewer-001
>
> 使用现有p1-pro-audit，执行一次PRE。
>
> Spec新PRE有效通过后，
> 允许一次真实Spec Reviewer调用。
>
> Quality Reviewer的R3 PRE原判COMPLIANT，
> 且Quality角色当时没有实际启动。
>
> 若原Quality PRE仍有效、对应角色尚未启动，
> 且关键输入与授权范围没有发生实质变化，
> 允许复用其原PRE并执行原定一次Quality任务；
> 不重复调用Quality PRE。
>
> 双审完成且相关合规条件满足后，
> 按已批准21G方案执行Tester Gate A。
>
> 每个新角色run_id最多一次角色调用，
> PRE/POST各最多一次，不自动重派。
>
> 不修改9份Soul。
> 不修改Harness、Provider、Hermes/P1/P0。
> 不引入WSL、Debian、容器、ACL或新框架。
> 不访问外机，不部署生产。
> 不修改冻结规格。
> 不切换模型。
>
> 本段授权完整，开始执行。

完整 R4 消息位于本会话用户原始消息；此文件仅保留与派发有关的逐字节选。旧 R3 授权与历史原判均另存，不覆盖。
