defmodule CoopGame.Plug do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Poison
  plug :dispatch


  get "/" do
    send_resp(conn, 200, "hello")
  end

  post "/register" do
    IO.inspect(conn, label: Hello)
    send_resp(conn, 200, "nana")
  end

  match(_) do
    send_resp(conn, 404, "Not found")
  end
end
