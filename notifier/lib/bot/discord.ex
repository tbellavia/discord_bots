defmodule Notifier.Bot.Discord do
  use Nostrum.Consumer

  @impl true
  def handle_event({:READY, data, _ws_state}) do
    Logger.info("Bot connected #{data.user.username}")
  end
end
