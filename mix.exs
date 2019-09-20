defmodule ExqThroughput.MixProject do
  use Mix.Project

  def project do
    [
      app: :exq_throughput,
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
      mod: {ExqThroughput.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exq, "~> 0.13.3"},
      {:jason, "~> 1.1"},
      {:benchee, "~> 1.0"},
      {:redix, ">= 0.0.0"},
      {:poolboy, "~> 1.5.1"}
    ]
  end
end
