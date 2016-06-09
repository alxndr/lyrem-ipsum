defmodule LyremIpsum.Mixfile do
  use Mix.Project

  def project do
    [app: :lyrem_ipsum,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  def application do
    [mod: {LyremIpsum, []},
     applications: [
       :cowboy,
       :gettext,
       :httpotion,
       :logger,
       :phoenix,
       :phoenix_html,
     ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:dialyze, "~> 0.2.0"},   # type checker
      {:floki, "~> 0.8"},       # html parser
      {:gettext, "~> 0.9"},
      {:httpotion, "~> 2.2.0"}, # http tool
      {:phoenix, "~> 1.1.4"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:poison, "~> 2.0"},      # json decoder
    ]
  end
end
