defmodule ElixirAnnouncer.Consumer do
  use Nostrum.Consumer

  @impl true
  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Bot connected #{data.user.username}")
  end
end

defmodule ElixirAnnouncer.Notifier do
  alias Nostrum.Struct.Embed
  require Logger
  use GenServer

  @elixir_channel Application.compile_env(:elixir_announcer, :discord_channel_id)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Keyword.put(opts, :name, __MODULE__))
  end

  def notify(story) do
    GenServer.cast(__MODULE__, {:notify, story})
  end

  @impl true
  def handle_cast({:notify, story}, state) do
    Logger.debug("notifying #{story["title"]} on discord")

    description = """
    Lien hackernews: https://news.ycombinator.com/item?id=#{story["id"]}
    """

    embed =
      %Embed{}
      |> Embed.put_title(story["title"])
      |> Embed.put_url(story["url"])
      |> Embed.put_description(description)

    Nostrum.Api.Message.create(@elixir_channel, embed: embed)
    {:noreply, state}
  end

  @impl true
  def init(:ok), do: {:ok, %{}}
end
