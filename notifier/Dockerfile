FROM elixir:1.18.3

WORKDIR /app

COPY . .

ARG MIX_ENV=dev
ENV MIX_ENV=${MIX_ENV}

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile && \
    mix compile

CMD ["mix", "run", "--no-halt"]