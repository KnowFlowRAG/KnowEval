# KnowFlow Eval - 快速开始

## 三步部署

### 1️⃣ 配置环境变量

```bash
cp .env.example .env
vi .env
```

必填项：
```bash
# 至少配置一个 LLM API Key
SILICONFLOW_API_KEY=sk-your-api-key-here

# 如果使用 RAGFlow
RAGFLOW_API_KEY=ragflow-your-key
RAGFLOW_BASE_URL=http://your-server-ip:9380/api/v1
```

### 2️⃣ 启动服务

```bash
./start.sh
```

### 3️⃣ 访问系统

浏览器打开：http://localhost:5003

## 常用命令

```bash
./start.sh    # 启动服务
./stop.sh     # 停止服务
./update.sh   # 更新镜像
./backup.sh   # 备份数据

# 查看日志
docker-compose logs -f
```

## 帮助文档

详细文档请查看 [README.md](README.md)
