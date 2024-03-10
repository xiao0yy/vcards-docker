FROM node:18-alpine as builder

RUN apk add --no-cache git
# NO Version or Tag
# Error: Command failed: git log -1 --pretty="format:%ci" /vCards/data/金融银行/湖北省农村信用社(农商银行).yaml
# rm data/*/*\(*;
RUN set -ex; \
    git clone --depth 1 https://github.com/metowolf/vCards /vCards; \
    cd /vCards; \
    npm install; \
    npm run radicale

FROM tomsquest/docker-radicale:3.1.8.3

COPY --from=builder /vCards/radicale /data/collections/collection-root/cn
COPY config /config/config
COPY rights /config/rights
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["radicale", "--config", "/config/config"]

