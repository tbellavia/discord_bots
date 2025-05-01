defmodule Stages.Filter do
  require Logger
  use GenStage

  def start_link(filters) do
    GenStage.start_link(__MODULE__, %{filters: filters}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:producer_consumer, state, subscribe_to: [Stages.Scraper]}
  end

  @impl true
  def handle_events(stories, _from, %{filters: filters} = state) do
    Logger.info("[FILTERING]")

    filtered_stories = filter_stories(stories, filters)

    {:noreply, filtered_stories, state}
  end

  defp filter_stories(stories, filters) do
    stories |> Enum.filter(fn story ->
      filters_match?(story.title, filters)
    end)
  end

  defp filters_match?(text, filters) when is_binary(text) and is_list(filters) do
    Regex.match?(regex_from_filters(filters), text)
  end

  defp regex_from_filters(filters) do
    filters =
      filters
      |> Enum.map(&Regex.escape/1)
      |> Enum.join("|")

    Regex.compile!("\\b(#{filters})\\b", "i")
  end
end
