defmodule ElixirAnnouncer.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_announcer,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx, :observer, :runtime_tools],
      mod: {ElixirAnnouncer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.10"},
      {:httpoison, "~> 2.0"},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ]
  end
end
