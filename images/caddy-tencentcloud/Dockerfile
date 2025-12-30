FROM caddy:builder-alpine AS builder

RUN go env -w GOPROXY=https://goproxy.cn \ 
  && xcaddy build \
  --with github.com/caddy-dns/tencentcloud \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/mholt/caddy-events-exec

FROM caddy:alpine

RUN apk add --no-cache curl jq

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
