defmodule Notifier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Notifier.Nostrum.Consumer,
      Notifier.Scraper,
      {Notifier.Filter, [["ai", "language", "programming"]]},
      Notifier.Discord,
    ]

    opts = [strategy: :one_for_one, name: Notifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
