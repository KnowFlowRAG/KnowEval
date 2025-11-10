# KnowFlow Eval - Docker 部署指南

[![Docker Image](https://img.shields.io/badge/docker-zxwei%2Fknowflow--eval-blue)](https://hub.docker.com/r/zxwei/knowflow-eval)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

KnowFlow Eval 是一个强大的 RAG（Retrieval-Augmented Generation）知识库评估系统，支持多种 LLM 模型和评估指标。

## 📋 目录

- [快速开始](#快速开始)
- [配置说明](#配置说明)
- [使用指南](#使用指南)
- [维护操作](#维护操作)
- [常见问题](#常见问题)

## 🚀 快速开始

### 前置要求

- Docker 20.10+
- Docker Compose 1.29+
- 至少 2GB 可用内存
- 至少 5GB 可用磁盘空间

### 一键部署

```bash
# 1. 克隆部署仓库
git clone https://github.com/KnowFlowRAG/KnowEval.git
cd KnowEval

# 2. 配置环境变量
cp .env.example .env
vi .env  # 编辑配置文件，填入你的 API 密钥

# 3. 启动服务
docker-compose up -d

# 4. 查看日志
docker-compose logs -f
```

### 访问服务

- **Web 界面**: http://localhost:5003
- **健康检查**: http://localhost:5003/health
- **API 文档**: http://localhost:5003/api/v1/docs

## ⚙️ 配置说明

### 必需配置

编辑 `.env` 文件，至少需要配置以下项：

```bash
# 1. 选择一个 LLM 提供商（至少配置一个）
SILICONFLOW_API_KEY=sk-your-api-key-here
# 或
OPENAI_API_KEY=sk-your-api-key-here
# 或
DEEPSEEK_API_KEY=sk-your-api-key-here

# 2. 如果使用 RAGFlow，配置以下项
RAGFLOW_API_KEY=ragflow-your-api-key-here
RAGFLOW_BASE_URL=http://your-server-ip:9380/api/v1
```

### 可选配置

```bash
# 默认模型（根据你的 API Key 选择）
DEFAULT_MODEL=Qwen/Qwen2.5-32B-Instruct

# 评估参数
EVALUATION_TIMEOUT=300      # 评估超时时间（秒）
MAX_WORKERS=2               # 并发评估数量
MAX_RETRIES=2               # 失败重试次数

# 日志级别
LOG_LEVEL=INFO              # DEBUG, INFO, WARNING, ERROR
```

### 目录结构

```
knowflow-eval-deploy/
├── docker-compose.yml      # Docker Compose 配置
├── .env.example            # 环境变量示例
├── .env                    # 环境变量（需自行创建）
├── README.md               # 本文档
├── data/                   # 数据库存储目录（自动创建）
├── logs/                   # 日志文件目录（自动创建）
└── tmp/                    # 临时文件目录（自动创建）
    ├── datasets/           # 数据集存储
    └── evaluation/         # 评估报告存储
        └── reports/
```

## 📖 使用指南

### 1. 创建数据集

访问 Web 界面 → 数据集管理 → 创建数据集

支持以下方式：
- 手动创建问答对
- 从 RAGFlow 导入
- 上传 JSON 文件

### 2. 配置评估任务

在评估页面配置：
- 选择数据集
- 选择评估指标（Answer Relevancy, Faithfulness, Context Precision 等）
- 选择 LLM 模型
- 设置评估参数

### 3. 查看评估报告

评估完成后：
- 在 Web 界面查看详细报告
- 下载 JSON 格式的评估结果
- 导出为 Excel 报表

## 🔧 维护操作

### 查看日志

```bash
# 查看实时日志
docker-compose logs -f

# 查看最近 100 行日志
docker-compose logs --tail=100

# 查看特定服务日志
docker-compose logs knowflow-eval
```

### 更新镜像

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d
```

### 备份数据

```bash
# 备份数据库和临时文件
tar -czf backup-$(date +%Y%m%d).tar.gz data/ tmp/

# 备份日志
tar -czf logs-backup-$(date +%Y%m%d).tar.gz logs/
```

### 清理资源

```bash
# 停止服务
docker-compose down

# 停止并删除数据卷（谨慎操作）
docker-compose down -v

# 清理旧日志
find logs/ -name "*.log.*" -mtime +7 -delete
```

### 重启服务

```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart knowflow-eval
```

## ❓ 常见问题

### 1. 服务无法启动

**检查端口占用**：
```bash
lsof -i :5003
```

**解决方案**：
- 修改 `docker-compose.yml` 中的端口映射
- 或停止占用端口的服务

### 2. 评估失败

**可能原因**：
- API 密钥无效或过期
- 网络连接问题
- 模型不可用

**解决方案**：
```bash
# 1. 检查环境变量
docker-compose exec knowflow-eval env | grep API_KEY

# 2. 测试 API 连接
docker-compose exec knowflow-eval curl -I https://api.siliconflow.cn

# 3. 查看详细错误日志
docker-compose logs --tail=50 knowflow-eval
```

### 3. 内存不足

**症状**：容器频繁重启

**解决方案**：
```yaml
# 在 docker-compose.yml 中限制资源
services:
  knowflow-eval:
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 2G
```

### 4. 数据库锁定

**症状**：`database is locked` 错误

**解决方案**：
```bash
# 1. 停止服务
docker-compose down

# 2. 检查数据库文件权限
ls -la data/

# 3. 重启服务
docker-compose up -d
```

### 5. 无法访问 RAGFlow

**检查配置**：
```bash
# 确保 RAGFLOW_BASE_URL 配置正确
cat .env | grep RAGFLOW_BASE_URL
```

**注意**：
- 如果 RAGFlow 在同一台服务器，使用服务器 IP 而不是 localhost
- 确保防火墙允许访问 RAGFlow 端口

### 6. 修改配置后不生效

**原因**：环境变量在容器启动时加载

**解决方案**：
```bash
# 修改 .env 后需要重启容器
docker-compose down
docker-compose up -d
```

## 📊 性能优化

### 调整并发数

```bash
# 在 .env 中调整
MAX_WORKERS=4               # 增加并发评估数量（根据服务器性能）
```

### 调整超时时间

```bash
# 在 .env 中调整
EVALUATION_TIMEOUT=600      # 增加超时时间（针对慢速 API）
```

## 🔒 安全建议

1. **保护环境变量**：确保 `.env` 文件不被提交到 Git
2. **限制 CORS**：生产环境修改 `CORS_ORIGINS` 为实际域名
3. **使用 HTTPS**：在生产环境使用反向代理（Nginx/Caddy）
4. **定期更新**：及时拉取最新镜像修复安全漏洞
5. **备份数据**：定期备份 `data/` 和 `tmp/` 目录

## 📝 版本信息

当前镜像版本：`zxwei/knowflow-eval:latest`

查看版本历史：https://hub.docker.com/r/zxwei/knowflow-eval/tags

## 🤝 支持与反馈

- 问题反馈：[GitHub Issues](https://github.com/KnowFlowRAG/KnowEval/issues)
- 源码仓库：[KnowFlowRAG Organization](https://github.com/KnowFlowRAG)

## 📄 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。
