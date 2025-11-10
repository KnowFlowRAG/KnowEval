# 贡献指南

感谢你对 KnowFlow Eval 的关注！

## 问题反馈

如果你在使用过程中遇到问题，请按以下步骤操作：

### 1. 检查文档

- [README.md](README.md) - 完整部署文档
- [QUICKSTART.md](QUICKSTART.md) - 快速开始指南
- [CHANGELOG.md](CHANGELOG.md) - 版本更新日志

### 2. 常见问题

在提交 Issue 之前，请先查看 [README.md](README.md) 的"常见问题"章节。

### 3. 提交 Issue

如果问题未解决，请提交 Issue 并包含：

- **环境信息**：
  - 操作系统及版本
  - Docker 版本
  - Docker Compose 版本

- **配置信息**（隐藏敏感数据）：
  - `.env` 配置项（移除 API Key）
  - `docker-compose.yml` 修改内容

- **错误信息**：
  - 完整的错误日志
  - 运行的命令
  - 期望的结果 vs 实际结果

- **复现步骤**：
  - 详细的操作步骤
  - 最小化复现用例

### Issue 模板

```markdown
**环境信息**
- OS: Ubuntu 22.04
- Docker: 24.0.5
- Docker Compose: 2.20.2

**问题描述**
[详细描述你遇到的问题]

**复现步骤**
1. 执行 `./start.sh`
2. 访问 http://localhost:5003
3. 看到错误...

**错误日志**
\`\`\`
[粘贴错误日志]
\`\`\`

**期望结果**
[描述期望看到的结果]

**实际结果**
[描述实际看到的结果]
```

## 功能建议

我们欢迎功能建议！请提交 Issue 并包含：

- **使用场景**：为什么需要这个功能？
- **预期效果**：功能应该如何工作？
- **替代方案**：是否考虑过其他方案？

## Pull Request

由于这是部署仓库，我们主要接受以下类型的 PR：

### 可接受的 PR

- ✅ 文档改进（错别字、说明不清等）
- ✅ 配置优化（环境变量、Docker Compose）
- ✅ 脚本增强（start.sh、update.sh 等）
- ✅ 示例补充（.env.example）

### 不接受的 PR

- ❌ 源码修改（请在源码仓库提交）
- ❌ Dockerfile 重大变更（需要重新构建镜像）

### PR 流程

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### PR 要求

- 清晰的标题和描述
- 如果修改了脚本，请测试运行
- 如果修改了文档，请检查格式
- 遵循现有的代码风格

## 文档贡献

文档改进非常重要！你可以：

- 修正错别字和语法错误
- 补充缺失的说明
- 添加更多示例
- 翻译文档（English version）
- 改进格式和可读性

## 行为准则

- 尊重他人
- 保持专业
- 建设性反馈
- 保护隐私（不要泄露 API Key 等敏感信息）

## 联系方式

- GitHub Issues: https://github.com/KnowFlowRAG/KnowEval/issues
- 讨论区: https://github.com/KnowFlowRAG/KnowEval/discussions

## 致谢

感谢所有贡献者！你的帮助让 KnowFlow Eval 变得更好。

---

**注意**：本仓库是部署仓库，源码开发请访问主仓库（私有）。
