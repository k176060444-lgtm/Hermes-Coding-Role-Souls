# TEST_ONLY 用户授权及角色模型

用户授权原文：“本授权视为该TEST_ONLY项目的需求及实验范围批准，不构成生产Gate批准。”

用户指定四个 Codex 角色 planner、quality_reviewer、tester_gate_a、arbitrator，模型 `group/gpt-6-luna`。用户指定五个 OpenCode 角色 p1-worker、p1-spec-reviewer、p1-worker-remediation、p1-tester-gate-b、p1-pro-audit；OpenCode “沿用当前已批准模型配置”。只读核查当前配置模型 `magpie/group/deepseek-v4.1-flash`，config.json SHA256 `65bc7174c17105edfa6be724879ba579a44a2362ba09d18cb10bf8f9b78ff936`。

以上是授权与请求值，不证明服务端实际模型身份。`observed_model` 无独立绑定证据时为 UNVERIFIED。每个角色最多一次真实任务调用、对应一次 PRE 和一次 POST；无自动重派和模型切换。角色、顺序、验收及条件见 USER_BRIEF 与派发任务。实验批准不构成生产 Gate、正式外部物理盲审或部署授权。
