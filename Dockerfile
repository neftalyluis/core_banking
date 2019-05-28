FROM elixir:1.8.1-alpine

COPY ./ /app/
WORKDIR /app/
RUN mix do local.rebar --force, local.hex --force, deps.get, compile

CMD mix run --no-halt