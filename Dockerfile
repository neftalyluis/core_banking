ARG ALPINE_VERSION=3.9

FROM elixir:1.9-alpine AS builder

ARG APP_NAME=core_banking
ARG APP_VSN=0.1.0
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN \
  mkdir -p /opt/built && \
  mix release && \
  cp -ar _build/${MIX_ENV}/rel/${APP_NAME}/ /opt/built && \
  cd /opt/built

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME=core_banking

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .

CMD trap 'exit' INT; /opt/app/${APP_NAME}/bin/${APP_NAME} daemon