# 给 21bao gpt-terra 的分段执行提示词

以本 ChatGPT 回复中的4段代码块为准，逐段发送；每段不超过3500字符。前3段只接收，第4段结束后才开始。

目标是把本 ZIP 的**19个文件**上传到用户已建立的公开仓库：
`https://github.com/k176060444-lgtm/Hermes-Coding-Role-Souls`

**不得创建新仓库、修改 Visibility、删除远端已有提交、强推、覆盖旧仓库。** 上传后回读核验并安装21bao本地9个角色配置（Codex 4个 + OpenCode 5个）。部署模型 gpt-terra 不作为9角色模型写入配置。

如果仓库非空或版本变化，以现场只读核验为准；遇到冲突，停止并报告。不得改 Hermes/P1/P0、其他非P1 Agent、模型供应商、密钥、任何外机，不调用 `codex exec`/`opencode run` 进行模型推理。

必要命令和脚本说明见 `DEPLOYMENT_21BAO.md`。
