defmodule Notifier.Scraper do
  require Logger
  use GenStage

  @interval :timer.seconds(20)
  @endpoint_topstories "https://hacker-news.firebaseio.com/v0/topstories.json"
  @endpoint_story "https://hacker-news.firebaseio.com/v0/item"

  def start_link(_), do: GenStage.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    schedule_tick()
    {:producer, %{buffer: [], demand: 0}}
  end

  def handle_info(:tick, %{buffer: buffer} = state) do
    schedule_tick()
    new_stories = fetch_stories()
    dispatch_stories(%{state | buffer: buffer ++ new_stories})
  end

  def handle_demand(incoming_demand, %{demand: demand} = state) do
    dispatch_stories(%{state | demand: demand + incoming_demand})
  end

  defp dispatch_stories(%{demand: 0} = state), do: {:noreply, [], state}

  defp dispatch_stories(%{buffer: buffer, demand: demand} = state) do
    {to_send, remaining} = Enum.split(buffer, demand)
    {:noreply, to_send, %{state | buffer: remaining, demand: demand - length(to_send)}}
  end

  defp fetch_stories() do
    Logger.debug("fetching stories from hackernews")

    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(@endpoint_topstories),
         {:ok, ids} <- JSON.decode(body) do
      ids
      |> Enum.map(&fetch_story/1)
      |> Enum.map(&Task.await/1)
    end
  end

  defp fetch_story(id) do
    Task.async(fn ->
      Logger.debug("fetching story #{id} from hackernews")
      url = "#{@endpoint_story}/#{id}.json"

      with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
           {:ok, story} <- JSON.decode(body) do
        story
      end
    end)
  end

  defp schedule_tick(), do: Process.send_after(self(), :tick, @interval)
end
