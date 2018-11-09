defmodule GE.MixProject do
  use Mix.Project

  def project do
    [
      app: :ge,
      version: "0.1.4",
      elixir: "~> 1.8-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [

      {:edeliver, "~> 1.4.2"},
      {:distillery, "~> 1.5"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},

      {:guardian, "~> 1.1.1"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 0.12"},

      {:entropy_string, "~> 1.3"},

      {:bamboo, "~> 1.1.0"},
      {:bamboo_smtp, "~> 1.6.0"},

      {:timex, "~> 3.0"},

      {:number, "~> 0.5.7"},
      {:poison, "~> 3.1"},

      {:number, "~> 0.5.7"}


    ]
  end
end
