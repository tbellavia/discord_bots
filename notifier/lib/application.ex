defmodule Notifier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    keywords = [
      "elixir",
      "language",
      "programming",
      "rust",
      "go",
      "golang",
      "space",
      "lisp",
      "clojure",
      "racket",
      "silicon valley",
      "san francisco",
      "book",
      "vim",
      "neovim",
      "nvim",
      "apple",
      "iphone",
      "macos",
      "mac"
    ]

    children = [
      Notifier.Bot.Discord,
      Stages.Scraper,
      {Stages.Filter, keywords},
      Stages.Discord
    ]

    opts = [strategy: :one_for_one, name: Notifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
