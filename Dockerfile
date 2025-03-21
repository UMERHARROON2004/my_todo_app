FROM elixir:1.15-alpine

RUN apk add --no-cache build-base git && \
    mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config ./config

RUN mix deps.get --only prod

COPY . .

RUN MIX_ENV=prod mix compile

EXPOSE 4000

CMD ["mix", "run", "--no-halt"]

