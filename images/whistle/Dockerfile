FROM node:20-alpine

# 安装必要的依赖
RUN apk add --no-cache bash

# 全局安装 whistle 和插件，清理缓存
RUN npm install -g whistle && \
    w2 i whistle.inspect && \
    npm cache clean --force && \
    rm -rf /root/.npm /tmp/*

# 创建启动脚本
RUN printf '#!/bin/bash\nw2 start "$@"\nwhile true; do sleep 1; done\n' > /start.sh && \
    chmod +x /start.sh

# 暴露默认端口
EXPOSE 8899

# 启动 whistle
ENTRYPOINT ["/start.sh"]
