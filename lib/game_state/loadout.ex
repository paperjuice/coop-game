defmodule CoopGame.GameState.Loadout do
  alias CoopGame.GameState.Weapon

  @type weapon :: %Weapon{} | nil

  defstruct [
    left_hand: weapon,
    right_hand: weapon
  ]
end
