defmodule Client.Application do
  use Application

  alias Client.Graphics

  def start(_type, _args) do
    Graphics.match_graphics(:credential_screen, false)

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
