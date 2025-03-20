defmodule MyPlugApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_plug_app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MyPlugApp.Application, []}, # Ensure this line is present
      extra_applications: [:logger, :plug_cowboy]
    ]
  end


  defp deps do
    [
      {:plug, "~> 1.17"},
      {:plug_cowboy, "~> 2.0"},
      {:plug_crypto, "~> 1.2"},  # Required for Plug.Session
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:oauth2, "~> 2.1"},
      {:ueberauth, "~> 0.10"},
      {:ueberauth_google, "~> 0.12"}
    ]
  end
end
