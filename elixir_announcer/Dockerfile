FROM elixir:1.18.3

COPY . /opt/bot

WORKDIR /opt/bot

RUN mix deps.get

ENTRYPOINT [ "mix", "run", "--no-halt" ]
