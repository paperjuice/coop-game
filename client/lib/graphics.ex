defmodule Client.Graphics do


  def main_screen() do
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
    #  1. Client.Api.register(<name>, <password>)
    #  2. Client.Api.login(<name>, <password>)
    #
    """)
    clear_screen()
  end

  def second_screen() do
    IO.puts( """
    ########################################
    #
    #
    #  COOP_GAME
    #
    #
    #--------------
    # ndsfkds 
    #--------------
    #  1. Client.Api.register(<name>, <password>)
    #  2. Client.Api.login(<name>, <password>)
    #
    """)
    clear_screen()
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

    Enum.each(1..(lines-15), fn _a ->
      IO.puts("")
    end)
  end
end
