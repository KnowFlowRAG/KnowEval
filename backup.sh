#!/bin/bash

# ===============================================
# KnowFlow Eval - 备份脚本
# ===============================================

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  KnowFlow Eval - 备份脚本${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# 创建备份目录
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

# 生成备份文件名
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/knowflow-eval-backup-$TIMESTAMP.tar.gz"

echo "创建备份..."
echo "备份目录:"
echo "  - data/    (数据库)"
echo "  - tmp/     (数据集和报告)"
echo "  - logs/    (日志)"
echo ""

# 创建备份
tar -czf "$BACKUP_FILE" data/ tmp/ logs/ .env 2>/dev/null || true

# 检查备份大小
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo -e "${GREEN}✓ 备份完成！${NC}"
echo ""
echo "备份文件: $BACKUP_FILE"
echo "备份大小: $BACKUP_SIZE"
echo ""

# 清理旧备份（保留最近 7 个）
echo "清理旧备份（保留最近 7 个）..."
cd "$BACKUP_DIR"
ls -t knowflow-eval-backup-*.tar.gz 2>/dev/null | tail -n +8 | xargs -r rm -f
cd ..

echo -e "${GREEN}✓ 清理完成${NC}"
echo ""
echo "恢复备份命令:"
echo "  tar -xzf $BACKUP_FILE"
