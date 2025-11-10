#!/bin/bash

# ===============================================
# KnowFlow Eval - 停止脚本
# ===============================================

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  KnowFlow Eval - 停止脚本${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# 停止服务
echo "停止服务..."
docker-compose down

echo -e "${GREEN}✓ 服务已停止${NC}"
echo ""
echo "如需清理数据，请手动删除以下目录:"
echo "  - data/    (数据库)"
echo "  - logs/    (日志)"
echo "  - tmp/     (临时文件)"
echo ""
echo "重新启动服务: ./start.sh"
