defmodule Notifier.Nostrum.Consumer do
  use Nostrum.Consumer

  @impl true
  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Bot connected #{data.user.username}")
  end
end
