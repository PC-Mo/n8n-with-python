# n8n-with-python

一个集成了 Python 和 uv 包管理器的 n8n Docker 镜像。

## 📦 包含内容

- **n8n** 2.1.4 - 工作流自动化工具
- **Node.js** v22.21.1 - JavaScript 运行时
- **npm** 11.6.4 - Node 包管理器
- **Python** 3.12.12 - Python 运行时
- **pip** 25.1.1 - Python 包管理器
- **uv** 0.9.18 - 快速 Python 包管理器

## 🚀 快速开始

### 构建镜像

```bash
docker build -t n8n-with-python .
```

### 运行容器

```bash
# 基本运行
docker run -d -p 5678:5678 n8n-with-python

# 带数据持久化
docker run -d -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  --name n8n \
  n8n-with-python

# 完整配置
docker run -d -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=your_password \
  -e WEBHOOK_URL=https://your-domain.com \
  --name n8n \
  --restart unless-stopped \
  n8n-with-python
```

### 访问 n8n

打开浏览器访问: `http://localhost:5678`

## 🔧 使用示例

### 在 n8n 中使用 Python

```python
# 在 n8n 的 Python 节点中
import requests

response = requests.get('https://api.example.com/data')
return response.json()
```

### 使用 uv 安装 Python 包

```bash
# 进入容器
docker exec -it n8n /bin/bash

# 使用 uv 安装包
uv pip install pandas numpy

# 或使用传统 pip
pip3 install pandas numpy
```

### 使用 npm 安装 Node 包

```bash
# 进入容器
docker exec -it n8n /bin/bash

# 安装全局包
npm install -g some-package

# 在工作目录安装
npm install package-name
```

## 📊 镜像信息

- **基础镜像**: Alpine Linux 3.23 (统一平台)
- **镜像大小**: 1.16GB
- **架构**: linux/arm64 (支持 Apple Silicon)

## 🔒 环境变量

常用 n8n 环境变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `N8N_BASIC_AUTH_ACTIVE` | 启用基本认证 | `false` |
| `N8N_BASIC_AUTH_USER` | 认证用户名 | - |
| `N8N_BASIC_AUTH_PASSWORD` | 认证密码 | - |
| `WEBHOOK_URL` | Webhook URL | - |
| `N8N_PORT` | n8n 端口 | `5678` |
| `NODE_ENV` | Node 环境 | `production` |

完整的环境变量列表请查看 [n8n 官方文档](https://docs.n8n.io/hosting/configuration/environment-variables/)

## 🐳 Docker Compose

创建 `docker-compose.yml`:

```yaml
version: '3.8'

services:
  n8n:
    image: n8n-with-python:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=your_secure_password
      - WEBHOOK_URL=https://your-domain.com
    volumes:
      - n8n_data:/home/node/.n8n
    healthcheck:
      test: ["CMD-SHELL", "node -e \"require('http').get('http://localhost:5678/healthz', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})\""]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

volumes:
  n8n_data:
```

启动：

```bash
docker-compose up -d
```

## 🛠️ 故障排除

### 检查容器日志

```bash
docker logs n8n
```

### 进入容器调试

```bash
docker exec -it n8n /bin/bash
```

### 验证所有工具

```bash
docker exec n8n /bin/sh -c "node --version && npm --version && python3 --version && pip3 --version && uv --version && n8n --version"
```

### 重置 n8n 数据

```bash
# 停止容器
docker stop n8n

# 删除数据卷
docker volume rm n8n_data

# 重新启动
docker start n8n
```

## 📝 优化说明

此镜像已经过优化：
- ✅ 删除了文档和 markdown 文件
- ✅ 删除了 source map 文件
- ✅ 删除了测试文件和示例代码
- ✅ 添加了健康检查
- ✅ 优化了构建层

## 🔗 相关链接

- [n8n 官方文档](https://docs.n8n.io/)
- [n8n GitHub](https://github.com/n8n-io/n8n)
- [uv 文档](https://github.com/astral-sh/uv)

## 📄 许可证

见 [LICENSE](./LICENSE) 文件
