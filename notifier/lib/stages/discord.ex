defmodule Stages.Discord do
  require Logger

  alias Nostrum.Struct.Embed
  use GenStage

  @channel Application.compile_env(:notifier, :discord_channel_id)

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    {:consumer, state, subscribe_to: [Stages.Filter]}
  end

  @impl true
  def handle_events(articles, _from, state) do
    Logger.info("[DISCORD CONSUMER]")

    for article <- articles do
      description = """
      Lien hackernews: https://news.ycombinator.com/item?id=#{article.id}
      """

      embed =
        %Embed{}
        |> Embed.put_title(article.title)
        |> Embed.put_url(article.url)
        |> Embed.put_description(description)

      Nostrum.Api.Message.create(@channel, embed: embed)
      Logger.info("posting #{article.id}#('#{article.title}') on discord")
    end

    {:noreply, [], state}
  end
end
