# whatsapp-proxy

## 本人使用debian12系统
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
