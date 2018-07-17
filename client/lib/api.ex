defmodule Client.Api do
  @moduledoc false

  alias Client.Graphics

  @url "http://localhost:9999"

  @register_route "/register"
  @login_route "/login"

  @content_type {"Content-Type", "application/json"}

  def register(name, password) do
    request = %{
      "name" => name,
      "password" => password
    }

    parse_request = Poison.encode!(request)

    {:ok, response} = HTTPoison.post(@url <> @register_route, parse_request, [@content_type])

    case response.status_code do
      200 ->
        Graphics.match_graphics(:register_response, 200)

      409 ->
        Graphics.match_graphics(:register_response, 409)
    end
  end

  def login(name, password) do
    request = %{
      "name" => name,
      "password" => password
    }

    parse_request = Poison.encode!(request)

    {:ok, response} = HTTPoison.post(@url <> @login_route, parse_request, [@content_type])

    case response.status_code do
      200 ->
        Graphics.match_graphics(:login_response, 200)

      409 ->
        Graphics.match_graphics(:login_response, 409)
    end
  end
end
