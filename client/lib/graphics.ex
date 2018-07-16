defmodule Client.Graphics do


  def main_screen(is_registered?) do
    clear_screen()

    register =
    if is_registered?,
    do: "#",
    else: "#  1. Client.Api.register(<name>, <password>)"

    IO.puts("""
    ########################################
    #
    #
    #  COOP_GAME
    #
    #
    #--------------
    #  ACTIONS
    #--------------
    #{register}
    #  2. Client.Api.login(<name>, <password>)
    #
    """)
  end

  def register_response(response) do
    clear_screen()
    case response do
      200 -> " # REGISTERED SUCCESSFULLY!"
      409 -> " # REGISTER FAILED :("
    end
    IO.puts( """
    ########################################
    #
    #
    #
    #
    #
    #--------------
    # REGISTERED SUCCESSFULLY!
    #--------------
    #
    # wait a sec
    #
    """)

    Process.sleep(2500)
    main_screen(true)
  end

  def login_response(response) do
    clear_screen()
    case response do
      200 -> " # LOGIN SUCCESSFULLY!"
      409 -> " # LOGIN FAILED :("
    end
    IO.puts( """
    ########################################
    #
    #
    #
    #
    #
    #--------------
    # LOGIN SUCCESSFULLY!
    #--------------
    #
    # wait a sec
    #
    """)

    Process.sleep(2500)
    main_menu()
  end

  def main_menu() do
    clear_screen()
    IO.puts( """
    ########################################
    #
    #
    #
    #--------------
    # ACTIONS:
    #--------------
    # 1. Find room
    # 2. Create room
    # 3. Join Room
    # 4. Inventory
    #
    """)
  end


  #--------------
  # PRIVATE
  #--------------
  defp clear_screen do
    {string, _} = System.cmd("tput", ["lines"])
    lines =
      string
      |> String.trim()
      |> String.to_integer

    Enum.each(1..lines, fn _a ->
      IO.puts("")
    end)
  end
end
