import Config

scraping_interval =
  case Mix.env() do
    :prod ->
      # Ex: lire une variable d'env et transformer en heures
      System.get_env("SCRAPING_INTERVAL", "1")
      |> String.to_integer()
      |> :timer.hours()

    :dev ->
      # Ex: lire une variable d'env et transformer en secondes
      System.get_env("SCRAPING_INTERVAL", "10")
      |> String.to_integer()
      |> :timer.seconds()

    _ ->
      raise "Unsupported environment: #{Mix.env()}"
  end

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto,
  gateway_intents: :all

config :notifier,
  discord_channel_id: 1_365_639_551_925_747_722,
  scraping_interval: scraping_interval
