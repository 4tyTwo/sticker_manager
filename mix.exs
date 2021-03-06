defmodule Debt.MixProject do
  use Mix.Project

  def project do
    [
      app: :debt,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :apps_direct
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug, :cowboy, :jason],
      env: [],
      mod: {Debt.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mogrify, "~> 0.7.3"},
      {:nadia, "~> 0.6.0"},
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.2"},
      {:quantum, "~> 3.0-rc"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:logger_logstash_formatter,
       git: "https://github.com/rbkmoney/logger_logstash_formatter.git", branch: :master},
      {:plug_cowboy, "~> 2.1.3"}
    ]
  end
end
