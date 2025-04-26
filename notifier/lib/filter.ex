defmodule Notifier.Filter do
  require Logger
  use GenStage

  def start_link(filters) do
    GenStage.start_link(__MODULE__, %{filters: filters}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:producer_consumer, state, subscribe_to: [Notifier.Scraper]}
  end

  @impl true
  def handle_events(stories, _from, %{filters: filters} = state) do
    Logger.info("[FILTERING]")
    filtered_stories =
      filters
      |> Enum.map(&filter_stories(stories, &1))
      |> Enum.flat_map(& &1)

    {:noreply, filtered_stories, state}
  end

  defp filter_stories(stories, filter) do
    Enum.filter(stories, fn story ->
      story["title"] |> String.downcase() |> String.contains?(filter)
    end)
  end
end
