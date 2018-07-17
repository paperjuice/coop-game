defmodule Client.Graphics do
  @type code ::
          :credential_screen
          | :register_response
          | :login_response
          | :main_menu

  @spec match_graphics(code()) :: String.t()
  def match_graphics(code, additional_opts \\ nil) do
    case code do
      :credential_screen -> main_screen(additional_opts)
      :register_response -> register_response(additional_opts)
      :login_response    -> login_response(additional_opts)
      :main_menu         -> main_menu()
    end

    clear_screen()
  end

  defp main_screen(is_registered?) do
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

  defp register_response(response) do
    case response do
      200 -> " # REGISTERED SUCCESSFULLY!"
      409 -> " # REGISTER FAILED :("
    end

    IO.puts("""
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
    clear_screen()
    Process.sleep(2500)
    main_screen(true)
  end

  defp login_response(response) do
    case response do
      200 -> " # LOGIN SUCCESSFULLY!"
      409 -> " # LOGIN FAILED :("
    end

    IO.puts("""
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

    clear_screen()
    Process.sleep(2500)
    main_menu()
  end

  defp main_menu() do
    IO.puts("""
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

  # --------------
  # PRIVATE
  # --------------
  defp clear_screen do
    {string, _} = System.cmd("tput", ["lines"])

    lines =
      string
      |> String.trim()
      |> String.to_integer()

    Enum.each(1..(lines-16), fn _a ->
      IO.puts("")
    end)
  end
end
