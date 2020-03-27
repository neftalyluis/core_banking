defmodule CoreBanking.MixProject do
  use Mix.Project

  def project do
    [
      app: :core_banking,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CoreBanking.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:uuid, "~> 1.1"},
      {:jason, "~> 1.1"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:credo, "~> 1.3.2", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:ex_spec, "~> 2.0", only: :test}
    ]
  end
end
