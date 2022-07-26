# Tickets

**TODO: Add description**

## Installation



```elixir
defp deps do
    [
      {:broadway, "~> 1.0"},
      {:broadway_rabbitmq, "~> 0.7.2"},
      {:amqp, "~> 3.1"},
      {:remix, "~> 0.0.2"},
      {:lager, github: "basho/lager"}
    ]
  end
```

require rabbitmq


```elixir
iex -S mix

send_messages.(500)
```
