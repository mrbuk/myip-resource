FROM alpine:edge

RUN apk --no-cache add \
  bash \
  curl \
  gzip \
  jq \
  libressl

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
