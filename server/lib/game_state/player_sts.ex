defmodule CoopGame.GameState.PlayerSts do
  alias CoopGame.GameState.Loadout
  defstruct [
    level: 1,
    max_xp: 50,
    current_xp: 0,
    max_hp: 50,
    current_hp: 50,
    special_abilities: [],
    loadout: %Loadout{},
    inventory: []
  ]
end
