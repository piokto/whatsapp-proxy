#!/bin/bash

# **********************************************************
# *                                                        *
# *  使用Docker设置WhatsApp代理的脚本                     *
# *  作者: Piokto                                          *
# *  GitHub: https://github.com/piokto                     *
# *  系统: Debian 12                                       *
# *                                                        *
# **********************************************************

# 定义一个函数用于显示状态信息
function status_message {
    echo "============================"
    echo "$1"
    echo "============================"
}

# 更新本地包
status_message "正在更新本地包"
sudo apt update

# 安装Docker
status_message "正在安装Docker"
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
rm test-docker.sh

# 拉取WhatsApp Docker镜像
status_message "正在拉取WhatsApp Docker镜像"
docker pull facebook/whatsapp_proxy:latest

# 克隆存储库到本地服务器
status_message "正在克隆存储库到本地服务器"
git clone https://github.com/WhatsApp/proxy.git

# 导航到存储库目录
cd proxy

# 构建Docker镜像
status_message "正在构建Docker镜像"
docker build . -t whatsapp_proxy:1.0

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
