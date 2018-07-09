defmodule CoopGame.GameState.GameState do
  alias CoopGame.GameState.PlayerSts


  @type current_screen :: :intro | :register_screen | :login_screen



  defstruct [
    current_screen: current_screen,
    is_loggedin: false,
    player_sts: %PlayerSts{},
    room_id: 0
  ]
end
