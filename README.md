# Custom Docker Images

自动构建和维护的 Docker 镜像集合，当基础镜像或依赖更新时自动重新构建。

## 📦 镜像列表

| 镜像名 | 基础镜像 | 说明 |
|--------|----------|------|
| `pptag/n8n-python` | `docker.n8n.io/n8nio/n8n:latest` | 集成 Python 和 uv 的 n8n |
| `pptag/caddy-tencentcloud` | `caddy:alpine` | 集成腾讯云 DNS 插件的 Caddy |
| `pptag/whistle` | `node:20-alpine` | Web 调试代理工具 |

## 🚀 快速使用

### n8n-python

集成了 Python 3.12、pip、uv 包管理器的 n8n 镜像。

```bash
docker run -d -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  --name n8n \
  pptag/n8n-python
```

**包含内容：**
- n8n - 工作流自动化工具
- Python 3.12 + pip
- uv - 快速 Python 包管理器

### caddy-tencentcloud

集成腾讯云 DNS 插件的 Caddy 服务器，支持自动 HTTPS 证书申请。

```bash
docker run -d -p 80:80 -p 443:443 \
  -v caddy_data:/data \
  -v /path/to/Caddyfile:/etc/caddy/Caddyfile \
  pptag/caddy-tencentcloud
```

**包含插件：**
- `caddy-dns/tencentcloud` - 腾讯云 DNS 验证
- `mholt/caddy-ratelimit` - 速率限制
- `mholt/caddy-events-exec` - 事件执行

### whistle

Web 调试代理工具，支持抓包、Mock、重写等功能。

```bash
docker run -d -p 8899:8899 \
  --name whistle \
  pptag/whistle
```

**包含插件：**
- `whistle.inspect` - 增强调试功能

## 🔄 自动更新机制

- 每天 UTC 02:00 自动检查基础镜像更新
- 检测到更新时自动构建并推送新版本
- whistle 镜像额外监控 npm 包版本更新
- 支持手动触发构建

## 📁 项目结构

```
.
├── images/
│   ├── images.json              # 镜像配置
│   ├── n8n-python/
│   │   ├── Dockerfile
│   │   └── node-packages.txt
│   ├── caddy-tencentcloud/
│   │   └── Dockerfile
│   └── whistle/
│       └── Dockerfile
├── .digests/                    # 基础镜像 digest 记录
└── .github/workflows/
    └── build-and-push.yml       # 自动构建 workflow
```

## 🛠️ 添加新镜像

1. 在 `images/` 下创建新目录和 Dockerfile
2. 在 `images/images.json` 中添加配置：

```json
{
  "name": "your-image",
  "context": "images/your-image",
  "dockerfile": "Dockerfile",
  "image": "pptag/your-image",
  "base_image": "base:tag",
  "digest_file": ".digests/your-image",
  "platforms": "linux/amd64,linux/arm64",
  "paths": ["images/your-image/**"]
}
```

3. 创建空的 digest 文件：`touch .digests/your-image`

## 📄 许可证

见 [LICENSE](./LICENSE) 文件
