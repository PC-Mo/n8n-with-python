# Stage 1: 下载 uv 二进制文件
FROM debian:bookworm-slim AS uv-downloader

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    rm -rf /var/lib/apt/lists/*

# Stage 2: 最终镜像（n8n 基于 Debian）
FROM docker.n8n.io/n8nio/n8n:latest

USER root

# 安装 Python 及编译依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    gcc \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

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
