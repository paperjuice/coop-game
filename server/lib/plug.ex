defmodule CoopGame.Plug do
  use Plug.Router

  alias CoopGame.Model.Storage
  alias CoopGame.HttpResponse, as: HR

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Poison
  plug :dispatch


  get "/" do
    send_resp(conn, 200, "hello")
  end

  post "/register" do
    %{ "name" => name,
      "password" => password
    } = conn.body_params

    resp = Storage.register_player(name, password)

    conn =
      case resp do
        {:ok, msg} ->
          Map.put(conn, :resp_body, HR.match(msg))
        {:error, error} ->
          Map.put(conn, :resp_body, HR.match(error))
      end

    send_resp(conn,
      conn.resp_body["http_code"],
      conn.resp_body["message"]
    )
  end

  post "/login" do
    %{ "name" => name,
      "password" => password
    } = conn.body_params


    resp = Storage.login_player(name, password)

    conn =
      case resp do
        {:ok, msg} ->
          Map.put(conn, :resp_body, HR.match(msg))
        {:error, error} ->
          Map.put(conn, :resp_body, HR.match(error))
      end

    send_resp(conn,
      conn.resp_body["http_code"],
      conn.resp_body["message"]
    )
  end

  match(_) do
    send_resp(conn, 404, "Not found")
  end
end
