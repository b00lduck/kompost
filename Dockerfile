FROM alpine

RUN apk add --no-cache curl jq yq bash docker docker-compose

WORKDIR /kompost

COPY entrypoint.sh /kompost
ADD modules /kompost/modules

ENTRYPOINT ["/kompost/entrypoint.sh"]
