defmodule CoopGame.Model.Storage do
  alias :mnesia, as: Mnesia

  @player_table Player
  @player_fields [
    :id,
    :name,
    :password,
    :token
  ]

  def init do
    Mnesia.create_schema([node()])
    Mnesia.start()

    create_table(@player_table, @player_fields)
  end

  @spec register_player(Plug.Conn.t, String.t(), String.t())
    :: {:atomic, :ok} | {:abort, String.t()}
  def register_player(conn, name, password) do
    id = Mnesia.table_info(Player, :size)
    encoded_password = Base.encode64(password)
    token = System.os_time()

    resp =
    if player_exists?(name) do
      {:error, "player_exists"}
    else
      Mnesia.transaction(fn ->
        Mnesia.write({@player_table, id + 1, name, encoded_password, token})
      end)

      {:ok, "reg_ok"}
    end
  end

  def login_player(conn, name, password) do
    decode_password = Base.encode64(password)

    {:atomic, response} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({@player_table, :_, name, decode_password, :_})
      end)

    case response do
      [] ->
        {:error, "user_doesnt_exist"}
      _ ->
        {:ok, "login_ok"}
    end
  end

  @spec player_exists?(String.t()) :: boolean()
  def player_exists?(name) do
    {:atomic, response} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({@player_table, :_, name, :_, :_})
      end)
    case response do
      [] -> false
      _ -> true
    end
  end

# =================== #
#       PRIVATE       #
# =================== #
  defp create_table(table_name, attributes) do
    response =
      Mnesia.create_table(
        table_name,
        [attributes: attributes
        ]
      )

      case response do
        {:aborted, error} ->
          IO.puts("Mnesia exit with the following error: #{inspect(error)}")
        {:atomic, _msg} -> IO.puts("Mnesia started successfully")
      end
  end

end
