defmodule CoopGame.GameState.Loadout do
  alias CoopGame.GameState.Weapon

  @type weapon :: %Weapon{} | nil

  defstruct [
    right_hand: nil,
    left_hand: %Weapon{}
  ]
end
