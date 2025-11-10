#!/bin/bash

# ===============================================
# KnowFlow Eval - 发布前自动检查脚本
# ===============================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  KnowFlow Eval - 发布前检查${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 检查函数
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

# 1. 检查必需文件
echo -e "${BLUE}[1/8] 检查必需文件...${NC}"
for file in README.md QUICKSTART.md CHANGELOG.md LICENSE docker-compose.yml Dockerfile .env.example .gitignore; do
    if [ -f "$file" ]; then
        check_pass "$file 存在"
    else
        check_fail "$file 缺失"
    fi
done
echo ""

# 2. 检查脚本权限
echo -e "${BLUE}[2/8] 检查脚本权限...${NC}"
for script in start.sh stop.sh update.sh backup.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            check_pass "$script 可执行"
        else
            check_fail "$script 不可执行 (运行: chmod +x $script)"
        fi
    else
        check_fail "$script 不存在"
    fi
done
echo ""

# 3. 检查敏感信息
echo -e "${BLUE}[3/8] 检查敏感信息...${NC}"

# 检查是否有真实 API Key
if grep -r "sk-[a-zA-Z0-9]\{20,\}" . --exclude-dir=.git --exclude="*.sh" 2>/dev/null; then
    check_fail "发现疑似真实 API Key"
else
    check_pass "未发现真实 API Key"
fi

# 检查是否有 .env 文件
if [ -f ".env" ]; then
    check_warn ".env 文件存在（应该只有 .env.example）"
else
    check_pass ".env 文件不存在"
fi

# 检查是否有数据文件
if [ -d "data" ] && [ "$(ls -A data)" ]; then
    check_warn "data/ 目录不为空"
else
    check_pass "data/ 目录为空或不存在"
fi

if [ -d "logs" ] && [ "$(ls -A logs)" ]; then
    check_warn "logs/ 目录不为空"
else
    check_pass "logs/ 目录为空或不存在"
fi
echo ""

# 4. 检查 Docker 镜像名称
echo -e "${BLUE}[4/8] 检查 Docker 配置...${NC}"
if grep -q "zxwei/knowflow-eval" docker-compose.yml; then
    check_pass "docker-compose.yml 镜像名称正确"
else
    check_fail "docker-compose.yml 镜像名称错误"
fi
echo ""

# 5. 检查占位符
echo -e "${BLUE}[5/8] 检查文档占位符...${NC}"
if grep -r "yourusername" . --exclude-dir=.git --exclude="*.sh" 2>/dev/null; then
    check_warn "发现 'yourusername' 占位符（需要替换为实际用户名）"
else
    check_pass "未发现 'yourusername' 占位符"
fi

if grep -r "your-email@example.com" . --exclude-dir=.git --exclude="*.sh" 2>/dev/null; then
    check_warn "发现 'your-email@example.com' 占位符（需要替换为实际邮箱）"
else
    check_pass "未发现邮箱占位符"
fi
echo ""

# 6. 检查 .gitignore
echo -e "${BLUE}[6/8] 检查 .gitignore...${NC}"
if grep -q "^\.env$" .gitignore; then
    check_pass ".gitignore 包含 .env"
else
    check_fail ".gitignore 缺少 .env"
fi

if grep -q "^data/" .gitignore; then
    check_pass ".gitignore 包含 data/"
else
    check_fail ".gitignore 缺少 data/"
fi
echo ""

# 7. 检查环境变量示例
echo -e "${BLUE}[7/8] 检查环境变量配置...${NC}"
required_vars=("OPENAI_API_KEY" "SILICONFLOW_API_KEY" "RAGFLOW_API_KEY" "DEFAULT_MODEL")
for var in "${required_vars[@]}"; do
    if grep -q "$var" .env.example; then
        check_pass ".env.example 包含 $var"
    else
        check_warn ".env.example 缺少 $var"
    fi
done
echo ""

# 8. 检查 Git 状态
echo -e "${BLUE}[8/8] 检查 Git 状态...${NC}"
if [ -d ".git" ]; then
    check_warn "已经初始化 Git 仓库"

    # 检查未提交的更改
    if git diff-index --quiet HEAD -- 2>/dev/null; then
        check_pass "没有未提交的更改"
    else
        check_warn "有未提交的更改"
    fi
else
    check_pass "尚未初始化 Git 仓库（正常）"
fi
echo ""

# 总结
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  检查结果总结${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ 所有检查通过！可以发布${NC}"
    echo ""
    echo "下一步:"
    echo "  1. 查看 RELEASE_CHECKLIST.md"
    echo "  2. 初始化 Git: git init"
    echo "  3. 提交代码: git add . && git commit -m 'Initial commit'"
    echo "  4. 推送到 GitHub"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ 检查完成，有 $WARNINGS 个警告${NC}"
    echo ""
    echo "建议修复警告后再发布，或者确认警告可以忽略"
    exit 0
else
    echo -e "${RED}✗ 检查失败！发现 $ERRORS 个错误，$WARNINGS 个警告${NC}"
    echo ""
    echo "请修复上述错误后再发布"
    exit 1
fi
