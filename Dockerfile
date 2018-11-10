FROM alpine:edge

RUN apk --no-cache add \
  bash \
  curl \
  gzip \
  jq \
  libressl \
  bind-tools

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
