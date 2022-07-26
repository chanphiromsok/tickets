defmodule Tickets.MixProject do
  use Mix.Project

  def project do
    [
      app: :tickets,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :remix],
      erl_opts: [parse_transform: "lager_transform"],
      mod: {Tickets.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.0"},
      {:broadway_rabbitmq, "~> 0.7.2"},
      {:amqp, "~> 3.1"},
      {:remix, "~> 0.0.2"},
      {:lager, github: "basho/lager"}
    ]
  end
end
