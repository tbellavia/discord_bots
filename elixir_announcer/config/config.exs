import Config

defmodule EnvParser do
  def get_scraping_interval() do
    value = System.get_env("SCRAPING_INTERVAL", "10")
    {interval, _} = Integer.parse(value)

    case Mix.env() do
      :prod -> :timer.hours(interval)
      :dev -> :timer.seconds(interval)
      other -> raise "Unsupported Mix.env(): #{inspect(other)}"
    end
  end
end

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto,
  gateway_intents: :all

config :elixir_announcer,
  discord_channel_id: 1_363_275_989_261_484_112,
  scraping_interval: EnvParser.get_scraping_interval()
