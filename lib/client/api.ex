defmodule CoopGame.Client.Api do
  @moduledoc false

  alias CoopGraphics

  @url "http://localhost:9999"
  @register_route "/register"
  @content_type {"Content-Type", "application/json"}

  def start_game do
    Graphics.main_screen()
  end

  def register_screen() do
  end

  def register(name, password) do
    request =
    %{
      "name" => name,
      "password" => password
    }

    parse_request = Poison.encode!(request)

    HTTPoison.post(
      @url <> @register_route,
      parse_request,
      [@content_type]
    )
  end
end
