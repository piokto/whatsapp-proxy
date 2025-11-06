#!/bin/bash

# **********************************************************
# *                                                        *
# *  使用Docker设置WhatsApp代理的脚本                     *
# *  作者: Piokto                                          *
# *  GitHub: https://github.com/piokto                     *
# *  系统: 自动检测                                        *
# *                                                        *
# **********************************************************

# 定义颜色
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # 没有颜色

# 捕获错误
set -e

# 定义一个函数用于显示状态信息
function status_message {
    echo -e "${GREEN}============================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${GREEN}============================${NC}"
}

# 定义错误处理函数
function error_message {
    echo -e "${RED}错误: $1${NC}"
    exit 1
}

# 检测Linux发行版
function detect_linux_distribution {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
        status_message "检测到 Linux 发行版: $DISTRO $VERSION"
    else
        status_message "无法检测到 Linux 发行版，假设为 Debian"
        DISTRO="debian"
        VERSION="11"
    fi
}

# 更换apt源为阿里云
function change_apt_sources_to_aliyun {
    status_message "正在更换apt源到阿里云"
    
    # 备份原始sources.list
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d%H%M%S)
    
    case $DISTRO in
        debian)
            case $VERSION in
                10)
                    # Debian 10 Buster
                    echo "deb https://mirrors.aliyun.com/debian/ buster main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ buster main non-free contrib
deb https://mirrors.aliyun.com/debian-security buster/updates main
deb-src https://mirrors.aliyun.com/debian-security buster/updates main
deb https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" | sudo tee /etc/apt/sources.list
                    ;;
                11)
                    # Debian 11 Bullseye - 修复backports仓库配置
                    echo "deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib" | sudo tee /etc/apt/sources.list
                    # 添加注释掉的backports，用户可以手动取消注释如果需要
                    echo "# 如需使用backports仓库，请取消下面两行的注释
# deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
# deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" | sudo tee -a /etc/apt/sources.list
                    ;;
                12)
                    # Debian 12 Bookworm
                    echo "deb https://mirrors.aliyun.com/debian/ bookworm main non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free-firmware contrib
deb https://mirrors.aliyun.com/debian-security/ bookworm-security main non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free-firmware contrib" | sudo tee /etc/apt/sources.list
                    ;;
                *)
                    status_message "未知的Debian版本: $VERSION，使用默认源"
                    return 1
                    ;;
            esac
            ;;
        ubuntu)
            case $VERSION in
                18.04)
                    # Ubuntu 18.04 Bionic
                    echo "deb https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" | sudo tee /etc/apt/sources.list
                    ;;
                20.04)
                    # Ubuntu 20.04 Focal
                    echo "deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" | sudo tee /etc/apt/sources.list
                    ;;
                22.04)
                    # Ubuntu 22.04 Jammy
                    echo "deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" | sudo tee /etc/apt/sources.list
                    ;;
                *)
                    status_message "未知的Ubuntu版本: $VERSION，使用默认源"
                    return 1
                    ;;
            esac
            ;;
        *)
            status_message "不支持的Linux发行版: $DISTRO，跳过更换源"
            return 1
            ;;
    esac
    
    status_message "apt源更换完成"
    return 0
}

# 安装Docker函数
function install_docker {
    status_message "正在安装Docker"
    
    # 安装前的准备工作
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # 添加Docker官方GPG密钥
    curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # 设置稳定版仓库
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 安装Docker引擎
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # 启动Docker
    sudo systemctl start docker
    
    # 设置开机自启
    sudo systemctl enable docker
    
    # 创建docker组
    sudo groupadd -f docker
    
    # 将当前用户添加到docker组
    sudo usermod -aG docker $USER
    
    # 验证Docker是否正确安装
    sudo docker --version || error_message "Docker安装失败"
    
    status_message "Docker已成功安装"
}

# 检测Linux发行版
detect_linux_distribution

# 更换apt源为阿里云
change_apt_sources_to_aliyun
if [ $? -eq 0 ]; then
    status_message "成功更换为阿里云源"
else
    status_message "无法更换为阿里云源，继续使用默认源"
fi

# 更新本地包
status_message "正在更新本地包"
sudo apt update || error_message "更新软件源失败，请检查网络或软件源配置"

# 安装必要依赖
status_message "正在安装必要依赖"
sudo apt install -y curl git || error_message "安装必要依赖失败"

# 检测Docker是否已安装
if ! command -v docker &> /dev/null
then
    # 使用修改后的Docker安装函数
    install_docker
    
    # 通知用户可能需要重新登录
    status_message "Docker安装完成，请重新登录以应用docker组权限，然后再次运行此脚本"
    
    # 提示用户重新登录
    echo -e "${YELLOW}请运行以下命令重新登录后再继续：${NC}"
    echo -e "${GREEN}exec su -l $USER${NC}"
    
    # 退出脚本，避免在没有docker权限的情况下继续
    exit 0
else
    status_message "Docker已安装，跳过安装步骤"
fi

# 检查docker是否可运行(无需sudo)
if ! docker ps &>/dev/null; then
    status_message "您的用户无法直接运行docker命令，尝试添加到docker组"
    sudo groupadd -f docker
    sudo usermod -aG docker $USER
    status_message "请重新登录以应用更改，然后再次运行此脚本"
    echo -e "${YELLOW}请运行以下命令重新登录后再继续：${NC}"
    echo -e "${GREEN}exec su -l $USER${NC}"
    exit 0
fi

# 拉取WhatsApp Docker镜像
if ! docker image inspect facebook/whatsapp_proxy:latest &> /dev/null 2>&1
then
    status_message "正在拉取WhatsApp Docker镜像"
    docker pull facebook/whatsapp_proxy:latest || error_message "无法拉取WhatsApp Docker镜像"
else
    status_message "WhatsApp Docker镜像已存在，跳过拉取步骤"
fi

# 克隆存储库到本地服务器
if [ ! -d "proxy" ]; then
    status_message "正在克隆存储库到本地服务器"
    git clone https://github.com/WhatsApp/proxy.git || error_message "无法克隆WhatsApp代理存储库"
else
    status_message "存储库已存在，正在更新"
    cd proxy || error_message "无法进入proxy目录"
    # 设置git pull模式为fast-forward only
    git config pull.ff only
    git pull || error_message "无法更新WhatsApp代理存储库"
    cd .. || error_message "无法返回上级目录"
fi

# 导航到存储库目录
cd proxy || error_message "无法进入proxy目录"

# 检查Dockerfile是否存在
if [ ! -f "Dockerfile" ]; then
    status_message "在仓库根目录未找到Dockerfile，正在尝试查找..."
    
    # 查找可能的Dockerfile位置
    DOCKERFILE_PATH=$(find . -name "Dockerfile" -type f | head -n 1)
    
    if [ -n "$DOCKERFILE_PATH" ]; then
        # 找到Dockerfile，切换到其所在目录
        DOCKERFILE_DIR=$(dirname "$DOCKERFILE_PATH")
        status_message "找到Dockerfile在: $DOCKERFILE_DIR"
        cd "$DOCKERFILE_DIR" || error_message "无法进入Dockerfile所在目录"
    else
        # 尝试查找示例配置或说明
        status_message "未找到Dockerfile，尝试创建默认配置"
        
        # 创建一个基本的Dockerfile用于WhatsApp代理
        cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine AS builder

WORKDIR /app

# 如果存在源代码，则编译它
COPY . .
RUN if [ -f "go.mod" ]; then \
        go build -o whatsapp_proxy; \
    fi

# 第二阶段 - 最小运行环境
FROM alpine:latest

WORKDIR /app

# 如果第一阶段编译了代码，则复制二进制文件
COPY --from=builder /app/whatsapp_proxy* /app/ 2>/dev/null || true

# 复制现有的二进制文件或脚本（如果存在）
COPY *.sh /app/ 2>/dev/null || true
COPY *.js /app/ 2>/dev/null || true
COPY *.py /app/ 2>/dev/null || true

# 设置执行权限
RUN chmod +x /app/* 2>/dev/null || true

# 安装必要的运行时依赖
RUN apk add --no-cache ca-certificates

# 暴露WhatsApp代理所需端口
EXPOSE 80 443 5222 8080 8443 8222 8199 587 7777

# 如果有启动脚本，则使用它，否则保持容器运行
CMD if [ -f "/app/whatsapp_proxy" ]; then \
        /app/whatsapp_proxy; \
    elif [ -f "/app/server.sh" ]; then \
        /app/server.sh; \
    else \
        echo "WhatsApp代理已启动" && tail -f /dev/null; \
    fi
EOF
        status_message "已创建默认Dockerfile"
    fi
fi

# 构建Docker镜像
if ! docker image inspect whatsapp_proxy:1.0 &> /dev/null 2>&1
then
    status_message "正在构建Docker镜像"
    docker build . -t whatsapp_proxy:1.0 || error_message "构建Docker镜像失败"
else
    status_message "Docker镜像已存在，跳过构建步骤"
fi

# 检查是否已有容器在运行
if docker ps | grep whatsapp_proxy &>/dev/null; then
    status_message "WhatsApp代理容器已在运行"
    docker stop whatsapp_proxy || true
    docker rm whatsapp_proxy || true
fi

# 运行前检查端口是否被占用
status_message "检查端口是否被占用"
PORTS_TO_CHECK="80 443 5222 8080 8443 8222 8199 587 7777"
PORT_CONFLICT=0

for port in $PORTS_TO_CHECK; do
    if netstat -tuln 2>/dev/null | grep ":$port " > /dev/null || ss -tuln 2>/dev/null | grep ":$port " > /dev/null; then
        echo -e "${RED}端口 $port 已被占用${NC}"
        PORT_CONFLICT=1
    fi
done

if [ $PORT_CONFLICT -eq 1 ]; then
    echo -e "${YELLOW}存在端口冲突，请释放被占用的端口后再运行${NC}"
    exit 1
fi

# 运行代理
status_message "正在运行WhatsApp代理"
docker run -d \
    --name whatsapp_proxy \
    --restart unless-stopped \
    -p 80:80 \
    -p 443:443 \
    -p 5222:5222 \
    -p 8080:8080 \
    -p 8443:8443 \
    -p 8222:8222 \
    -p 8199:8199 \
    -p 587:587 \
    -p 7777:7777 \
    whatsapp_proxy:1.0 || error_message "启动WhatsApp代理容器失败"

# 验证容器是否正在运行
if ! docker ps | grep whatsapp_proxy &>/dev/null; then
    error_message "WhatsApp代理容器未能成功启动"
fi

# 显示本机IP地址
IP_ADDRESS=$(curl -s ifconfig.me || wget -qO- ifconfig.me || hostname -I | awk '{print $1}')
status_message "WhatsApp代理设置完成！"
echo -e "${GREEN}服务器IP地址: ${IP_ADDRESS}${NC}"
echo -e "${GREEN}通讯端口为5222，媒体端口为7777。${NC}"

# 检查BBR状态
function check_bbr {
    status=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null)
    if [[ "$status" == *"bbr"* ]]; then
        echo -e "${GREEN}BBR已启用！${NC}"
    else
        echo -e "${RED}BBR未启用。您可以通过以下命令启用BBR:${NC}"
        echo -e "${YELLOW}sudo modprobe tcp_bbr${NC}"
        echo -e "${YELLOW}echo 'tcp_bbr' | sudo tee -a /etc/modules-load.d/modules.conf${NC}"
        echo -e "${YELLOW}echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf${NC}"
        echo -e "${YELLOW}echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf${NC}"
        echo -e "${YELLOW}sudo sysctl -p${NC}"
    fi
}

check_bbr

# 显示docker日志查看命令
echo -e "${YELLOW}查看代理日志: ${NC}docker logs whatsapp_proxy"
echo -e "${YELLOW}停止代理: ${NC}docker stop whatsapp_proxy"
echo -e "${YELLOW}启动代理: ${NC}docker start whatsapp_proxy"
