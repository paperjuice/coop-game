defmodule CoopGame.MixProject do
  use Mix.Project

  def project do
    [
      app: :coop_game,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {CoopGame.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~>1.6.0"},
      {:cowboy, "~>2.4"},
      {:poison, ">=0.0.0"},
      {:httpoison, "~>1.2.0"}
    ]
  end
end
