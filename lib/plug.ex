defmodule CoopGame.Plug do
  use Plug.Router

  alias CoopGame.Model.Storage

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

    conn = Storage.add_new_player(conn, name, password)

    send_resp(conn,
      conn.resp_body["http_code"],
      conn.resp_body["message"]
    )
  end

  post "/login" do
    %{ "name" => name,
      "password" => password
    } = conn.body_params

    conn = Storage.login_player(conn, name, password)

    send_resp(conn,
      conn.resp_body["http_code"],
      conn.resp_body["message"]
    )
  end

  match(_) do
    send_resp(conn, 404, "Not found")
  end
end
