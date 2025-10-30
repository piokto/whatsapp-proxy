#!/bin/bash

# **********************************************************
# *                                                        *
# *  使用Docker设置WhatsApp代理的脚本                     *
# *  作者: Piokto                                          *
# *  GitHub: https://github.com/piokto                     *
# *  系统: Debian 12                                       *
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

# 更新本地包
status_message "正在更新本地包"
sudo apt update

# 检测Docker是否已安装
if ! command -v docker &> /dev/null
then
    status_message "Docker未安装，正在安装Docker"
    curl -fsSL https://test.docker.com -o test-docker.sh
    sudo sh test-docker.sh
    rm test-docker.sh
else
    status_message "Docker已安装，跳过安装步骤"
fi

# 拉取WhatsApp Docker镜像
if ! docker image inspect facebook/whatsapp_proxy:latest &> /dev/null
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
    status_message "存储库已存在，跳过克隆步骤"
fi

# 导航到存储库目录
cd proxy

# 构建Docker镜像
if ! docker image inspect whatsapp_proxy:1.0 &> /dev/null
then
    status_message "正在构建Docker镜像"
    docker build . -t whatsapp_proxy:1.0
else
    status_message "Docker镜像已存在，跳过构建步骤"
fi

# 手动运行代理
status_message "正在手动运行WhatsApp代理"
docker run -it \
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

status_message "WhatsApp代理设置完成！"
echo -e "${GREEN}通讯端口为5222，媒体端口为7777。${NC}"

# 检查BBR状态
function check_bbr {
    status=$(sysctl net.ipv4.tcp_congestion_control)
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
