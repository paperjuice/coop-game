defmodule CoopGame.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      { Plug.Adapters.Cowboy2,
        scheme: :http,
        plug: CoopGame.Plug,
        options: [port: 9999]
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end


end
