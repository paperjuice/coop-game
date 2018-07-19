defmodule CoopGame.Model.Storage do
  alias :mnesia, as: Mnesia

  alias CoopGame.Structs.{
    Player,
    Character,
    Weapon
  }

  @player_table Player
  @player_fields [
    :id,
    :name,
    :password,
    :token,
    :joined_room
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
    decode_pass = Base.encode64(password)
    player = find_player(name, decode_pass)

      case player do
        [] ->
          {:error, "player_doesnt_exist"}
        _ ->
          character = find_character_by_player_id(1)
          #TODO: get weapon id
          player_list=
            player
            |> hd()
            |> Tuple.to_list
            |> tl()

          player = build_structure(%{}, @player_fields, player_list)
          weapon = find_weapon_by_id(1)

          message = build_ok_response(player, character, weapon)
                    |> IO.inspect(label: MHEHE)
          {:ok,"login_ok", message}
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
        Mnesia.write({@player_table, id + 1, name, encoded_password, token, 0})
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
  end

  defp find_player(name, pass) do
    {:atomic, player} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({@player_table, :_, name, pass, :_, :_})
      end)

    player
  end

  defp find_character_by_player_id(id) do
    {:atomic, character} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({@character_table, id, :_, :_, :_, :_, :_, :_, :_})
      end)

    character_list=
      character
      |> hd()
      |> Tuple.to_list
      |> tl()

    build_structure(%{}, @character_fields, character_list)
  end

  defp find_weapon_by_id(id) do
    {:atomic, weapon} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({@weapon_table, id, :_, :_, :_})
      end)

    weapon_list=
      weapon
      |> hd()
      |> Tuple.to_list
      |> tl()

    build_structure(%{}, @weapon_fields, weapon_list)
  end

  defp build_ok_response(player, character, weapon) do
    wep = %Weapon{
      name: weapon.name,
      min_dmg: weapon.min_dmg,
      max_dmg: weapon.max_dmg
    }

    char = %Character{
      lvl: character.lvl,
      c_xp: character.c_xp,
      m_xp: character.m_xp,
      c_hp: character.c_hp,
      m_hp: character.m_hp,
      inventory: character.inventory,
      weapon: wep
    }

    %Player{
      name: player.name,
      token: player.token,
      joined_room: player.joined_room,
      character: char
    }
  end

  defp build_structure(map, [], []), do: map
  defp build_structure(map, key, value) do
    map = Map.put(map, hd(key), hd(value))
    build_structure(map, tl(key), tl(value))
  end

end
