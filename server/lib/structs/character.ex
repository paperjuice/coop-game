defmodule CoopGame.Structs.Character do
  @moduledoc false

  alias CoopGame.Structs.Weapon

  defstruct [
    lvl: 0,
    c_xp: 0,
    m_xp: 0,
    c_hp: 0,
    m_hp: 0,
    inventory: [],
    weapon: %Weapon{}
  ]
end
