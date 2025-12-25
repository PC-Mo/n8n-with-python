# Stage 1: 下载 uv 二进制文件
FROM alpine:latest AS uv-downloader

RUN apk add --no-cache curl && \
    curl -LsSf https://astral.sh/uv/install.sh | sh

# Stage 2: 最终镜像
FROM docker.n8n.io/n8nio/n8n:latest

USER root

# 安装 Python 及常用编译依赖（用于 pip install 编译 C 扩展）
RUN apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    gcc \
    musl-dev \
    libffi-dev

# 从第一阶段复制 uv
COPY --from=uv-downloader /root/.local/bin/uv /usr/local/bin/uv
COPY --from=uv-downloader /root/.local/bin/uvx /usr/local/bin/uvx

# 设置目录权限
RUN mkdir -p /home/node/.local && \
    chown -R node:node /home/node/.local

ENV PYTHONUNBUFFERED=1 \
    PATH="/home/node/.local/bin:$PATH"

# 验证安装
RUN python3 --version && pip3 --version && uv --version

USER node
WORKDIR /home/node
