defmodule Debt.MixProject do
  use Mix.Project

  def project do
    [
      app: :debt,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [
        template_image_path: "./resources/images/sticker_template.png", # strictly 512x512 pixels!
        bot_token_path: "./resources/bot.token"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:mogrify, "~> 0.7.3"}
    ]
  end
end
