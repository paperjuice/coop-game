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


  @spec add_new_player(String.t(), String.t())
    :: {:atomic, :ok} | {:abort, String.t()}
  def add_new_player(name, password) do
    id = Mnesia.table_info(Player, :size)
    encoded_password = Base.encode64(password)
    token = System.os_time()

    if player_exists?(name) do
      IO.puts("Player exists")
    else
      Mnesia.transaction(fn ->
        Mnesia.write({Player, id + 1, name, encoded_password, token})
      end)
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
          IO.puts("Mnesia exit with the following error: #{error}")
        {:atomic, _msg} -> IO.puts("Mnesia started successfully")
      end
  end

  defp player_exists?(name) do
    {:atomic, response} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({Player, :_, name, :_, :_})
      end)
    case response do
      [] -> false
      _ -> true
    end
  end

end
