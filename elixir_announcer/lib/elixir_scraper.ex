defmodule ElixirAnnouncer.Scraper do
  require Logger
  use GenServer

  @interval :timer.seconds(10)
  @topstories_endpoint "https://hacker-news.firebaseio.com/v0/topstories.json"
  @story_endpoint "https://hacker-news.firebaseio.com/v0/item"

  ## Server
  @impl true
  def init(:ok) do
    schedule_work()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:work, state) do
    work()
    schedule_work()
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state), do: {:noreply, state}

  def work() do
    Logger.debug("fetching stories from hackernews")
    response = HTTPoison.get!(@topstories_endpoint)
    {:ok, stories} = JSON.decode(response.body)

    stories
      = stories
      |> Enum.map(&get_story/1)
      |> Enum.map(&Task.await(&1))
    elixir_stories = Enum.filter(stories, &elixir_story?/1)
    Enum.each(elixir_stories, &notify_story/1)
  end

  defp notify_story(story) do
    Task.async(fn -> ElixirAnnouncer.Notifier.notify(story) end)
  end

  defp elixir_story?(story) do
    story["title"]
    |> String.downcase()
    |> String.contains?("elixir")
  end

  defp get_story(story_id) do
    Task.async(fn ->
      url = "#{@story_endpoint}/#{story_id}.json"
      Logger.debug("fetching story #{url}")
      response = HTTPoison.get!(url)
      {:ok, story} = JSON.decode(response.body)
      story
    end)
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @interval)
  end

  ## Client
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end
end
