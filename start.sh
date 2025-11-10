#!/bin/bash

# ===============================================
# KnowFlow Eval - 启动脚本
# ===============================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  KnowFlow Eval - 启动脚本${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: Docker 未安装${NC}"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}错误: Docker Compose 未安装${NC}"
    echo "请先安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# 检查 .env 文件是否存在
if [ ! -f .env ]; then
    echo -e "${YELLOW}警告: .env 文件不存在${NC}"
    echo "正在从 .env.example 创建 .env 文件..."
    cp .env.example .env
    echo -e "${YELLOW}请编辑 .env 文件，填入你的 API 密钥后再次运行此脚本${NC}"
    echo ""
    echo "必需配置项:"
    echo "  - SILICONFLOW_API_KEY (或其他 LLM API Key)"
    echo "  - RAGFLOW_API_KEY (如果使用 RAGFlow)"
    echo "  - RAGFLOW_BASE_URL (如果使用 RAGFlow)"
    exit 1
fi

# 检查必需的环境变量
echo "检查配置..."
source .env

if [ -z "$SILICONFLOW_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$DEEPSEEK_API_KEY" ]; then
    echo -e "${RED}错误: 至少需要配置一个 LLM API Key${NC}"
    echo "请在 .env 中配置以下之一:"
    echo "  - SILICONFLOW_API_KEY"
    echo "  - OPENAI_API_KEY"
    echo "  - DEEPSEEK_API_KEY"
    exit 1
fi

# 创建必需的目录
echo "创建必需的目录..."
mkdir -p data logs tmp/datasets tmp/evaluation/reports

# 拉取最新镜像
echo "拉取最新镜像..."
docker-compose pull

# 启动服务
echo "启动服务..."
docker-compose up -d

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务健康状态
echo "检查服务健康状态..."
for i in {1..30}; do
    if curl -f http://localhost:5003/health &> /dev/null; then
        echo -e "${GREEN}✓ 服务启动成功！${NC}"
        echo ""
        echo -e "${GREEN}================================================${NC}"
        echo -e "${GREEN}  服务访问信息${NC}"
        echo -e "${GREEN}================================================${NC}"
        echo ""
        echo "  Web 界面: http://localhost:5003"
        echo "  健康检查: http://localhost:5003/health"
        echo ""
        echo "查看日志: docker-compose logs -f"
        echo "停止服务: docker-compose down"
        echo ""
        exit 0
    fi
    echo "等待中... ($i/30)"
    sleep 2
done

echo -e "${YELLOW}警告: 服务可能未正常启动${NC}"
echo "请查看日志: docker-compose logs"
exit 1
