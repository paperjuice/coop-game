defmodule CoopGame.GameState.GameState do
  alias CoopGame.GameState.{
    PlayerSts
  }

  @type current_screen :: :intro | :register_screen | :login_screen


  defstruct [
    current_screen: :intro,
    is_loggedin: false,
    player_sts: %PlayerSts{}
  ]
end
