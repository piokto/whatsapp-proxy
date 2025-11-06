# whatsapp-proxy
此脚本仅供个人学习参考，如有问题请参考官方教程
### 修复更新说明：
#### 2025.11-7
修复 git pull 设置:
添加了 git config pull.ff only 设置，确保使用 fast-forward only 模式
Dockerfile 自动处理:
添加了检测 Dockerfile 是否存在的逻辑
如找不到，使用 find 命令在仓库中搜索
如果完全找不到，创建一个通用的默认 Dockerfile
默认 Dockerfile 包含多阶段构建，适应不同的源码类型
错误处理和可靠性提升:
使用 set -e 确保脚本遇到错误时停止
为所有关键操作添加错误检查
停止和移除已存在的容器，避免冲突
Apt 源处理优化:
修复了 Debian 11 的 backports 仓库配置问题

#### 2025.11-5
在仓库已存在的情况下正确实现了目录切换：
进入 proxy 目录进行更新
返回上级目录
之后再统一通过公共路径进入 proxy 目录
每个关键的目录操作都添加了错误检查，确保目录切换成功
完整保留了所有之前的优化改进，包括：
Docker 安装方法改进
阿里云源配置修正
错误处理增强
容器管理优化

## 手动安装
### 更新本地包

```language
apt update
```


### 安装docker


```language
curl -fsSL https://test.docker.com -o test-docker.sh
 sudo sh test-docker.sh
```


### 安装WhatsApp docker镜像

```language
docker pull facebook/whatsapp_proxy:latest
```


### 克隆存储库到本地服务器


```language
git clone https://github.com/WhatsApp/proxy.git
```


### 导航到存储库目录

```language
cd proxy

```

### 安装镜像

```language
docker build proxy/ -t whatsapp_proxy:1.0
```


> 连接时默认地址为服务器ip 通讯端口：**5222** 媒体端口：**7777**

### 手动运行代理


```language
docker run -it -p 80:80 -p 443:443 -p 5222:5222 -p 8080:8080 -p 8443:8443 -p 8222:8222 -p 8199:8199 -p 587:587 -p 7777:7777 whatsapp_proxy:1.0
```

## 一键搭建脚本
```language
curl -fsSL https://raw.githubusercontent.com/piokto/whatsapp-proxy/refs/heads/main/whatsapp.sh | bash
```
