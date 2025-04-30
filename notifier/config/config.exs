import Config

# scraping_interval =
#   fn env ->
#     System.get_env(env, "10")
#     |> String.to_integer()
#     |> :timer.seconds()
#   end

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto,
  gateway_intents: :all

config :notifier,
  discord_channel_id: 1_365_639_551_925_747_722,
  scraping_interval: :timer.seconds(30)
