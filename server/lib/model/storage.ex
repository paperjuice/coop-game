defmodule CoopGame.Model.Storage do
  alias :mnesia, as: Mnesia

  @player_table Player
  @player_fields [
    :id,
    :name,
    :password,
    :token
  ]

  @character_table Character
  @character_fields [
    :id,
    :lvl,
    :c_xp,
    :m_xp,
    :c_hp,
    :m_hp,
    :inventory,
    :weapon_id
  ]

  @weapon_table Weapon
  @weapon_fields [
    :id,
    :name,
    :min_dmg,
    :max_dmg
  ]

  def init do
    Mnesia.create_schema([node()])
    Mnesia.start()

    create_table(@player_table, @player_fields)
    create_table(@character_table, @character_fields)
    create_table(@weapon_table, @weapon_fields)
    add_initial_weapon()
  end

  @spec register_player(String.t(), String.t())
    :: {:atomic, :ok} | {:abort, String.t()}
  def register_player(name, password) do
    if player_exists?(name) do
      {:error, "player_exists"}
    else
      add_player(name, password)
    end
  end

  @spec login_player(String.t(), String.t())
    :: {:atomic, :ok} | {:abort, String.t()}
  def login_player(name, password) do
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
        {:atomic, _msg} ->
          IO.puts("Mnesia started successfully")
      end
  end

  defp add_player(name, pass) do
      id = Mnesia.table_info(@player_table, :size)
      token = System.os_time()
      encoded_password = Base.encode64(pass)

      #add player sts
      Mnesia.transaction(fn ->
        Mnesia.write({@player_table, id + 1, name, encoded_password, token})
      end)

      #add player character entry
      Mnesia.transaction(fn ->
        Mnesia.write (
          { @character_table,
            id + 1,
            1,  #lvl
            0,  #c_xp
            50, #m_xp
            50, #c_hp
            50, #m_hp
            [], #inventory
            1   #w_id
          }
        )
      end)

      {:ok, "reg_ok"}
  end

  defp add_initial_weapon do
    Mnesia.dirty_write({@weapon_table, 1, "Wooden stick", 3, 5})
    |> IO.inspect(label: AddInitialWeapon)
  end
end
