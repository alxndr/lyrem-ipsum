defmodule LyremIpsum.Mixfile do
  use Mix.Project

  def project do
    [app: :lyrem_ipsum,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:dialyze, "~> 0.2.0"},   # type checker
      {:floki, "~> 0.8"},       # html parser
      {:httpotion, "~> 2.2.0"}, # http tool
      {:poison, "~> 2.0"},      # json decoder
    ]
  end
end
