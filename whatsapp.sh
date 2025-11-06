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

# 定义一个函数用于显示状态信息
function status_message {
    echo -e "${GREEN}============================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${GREEN}============================${NC}"
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
        VERSION="12"
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
                    # Debian 11 Bullseye
                    echo "deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" | sudo tee /etc/apt/sources.list
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
sudo apt update

# 安装必要依赖
status_message "正在安装必要依赖"
sudo apt install -y curl git

# 检测Docker是否已安装
if ! command -v docker &> /dev/null
then
    status_message "Docker未安装，正在安装Docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    status_message "Docker安装完成，可能需要重新登录以应用组权限"
else
    status_message "Docker已安装，跳过安装步骤"
fi

# 拉取WhatsApp Docker镜像
if ! docker image inspect facebook/whatsapp_proxy:latest &> /dev/null 2>&1
then
    status_message "正在拉取WhatsApp Docker镜像"
    docker pull facebook/whatsapp_proxy:latest
else
    status_message "WhatsApp Docker镜像已存在，跳过拉取步骤"
fi

# 克隆存储库到本地服务器
if [ ! -d "proxy" ]; then
    status_message "正在克隆存储库到本地服务器"
    git clone https://github.com/WhatsApp/proxy.git
else
    status_message "存储库已存在，正在更新"
    cd proxy
    git pull
    cd ..
fi

# 导航到存储库目录
cd proxy

# 构建Docker镜像
if ! docker image inspect whatsapp_proxy:1.0 &> /dev/null 2>&1
then
    status_message "正在构建Docker镜像"
    docker build . -t whatsapp_proxy:1.0
else
    status_message "Docker镜像已存在，跳过构建步骤"
fi

# 运行前检查端口是否被占用
status_message "检查端口是否被占用"
PORTS_TO_CHECK="80 443 5222 8080 8443 8222 8199 587 7777"
PORT_CONFLICT=0

for port in $PORTS_TO_CHECK; do
    if netstat -tuln | grep ":$port " > /dev/null; then
        echo -e "${RED}端口 $port 已被占用${NC}"
        PORT_CONFLICT=1
    fi
done

if [ $PORT_CONFLICT -eq 1 ]; then
    echo -e "${YELLOW}存在端口冲突，请释放被占用的端口后再运行${NC}"
    exit 1
fi

# 手动运行代理
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
    whatsapp_proxy:1.0

# 显示本机IP地址
IP_ADDRESS=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
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
