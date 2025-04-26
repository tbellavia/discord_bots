defmodule Notifier.Discord do
  require Logger

  alias Nostrum.Struct.Embed
  use GenStage

  @channel Application.compile_env(:elixir_announcer, :discord_channel_id)

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    {:consumer, state, subscribe_to: [Notifier.Filter]}
  end

  @impl true
  def handle_events(stories, _from, state) do
    Logger.debug("[DISCORD CONSUMER]")
    for story <- stories do
      description = """
      Lien hackernews: https://news.ycombinator.com/item?id=#{story["id"]}
      """

      embed =
        %Embed{}
        |> Embed.put_title(story["title"])
        |> Embed.put_url(story["url"])
        |> Embed.put_description(description)

      Nostrum.Api.Message.create(@channel, embed: embed)
    end

    {:noreply, [], state}
  end
end
