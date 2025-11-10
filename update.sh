#!/bin/bash

# ===============================================
# KnowFlow Eval - 更新脚本
# ===============================================

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  KnowFlow Eval - 更新脚本${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# 备份数据
echo "备份数据..."
BACKUP_FILE="backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" data/ tmp/ 2>/dev/null || true
echo -e "${GREEN}✓ 数据已备份到: $BACKUP_FILE${NC}"

# 停止服务
echo "停止当前服务..."
docker-compose down

# 拉取最新镜像
echo "拉取最新镜像..."
docker-compose pull

# 启动服务
echo "启动更新后的服务..."
docker-compose up -d

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务健康状态
echo "检查服务健康状态..."
for i in {1..30}; do
    if curl -f http://localhost:5003/health &> /dev/null; then
        echo -e "${GREEN}✓ 更新成功！服务已重启${NC}"
        echo ""
        echo "查看日志: docker-compose logs -f"
        exit 0
    fi
    echo "等待中... ($i/30)"
    sleep 2
done

echo -e "${YELLOW}警告: 服务可能未正常启动${NC}"
echo "请查看日志: docker-compose logs"
echo ""
echo "如需回滚，可以从备份恢复: $BACKUP_FILE"
exit 1
