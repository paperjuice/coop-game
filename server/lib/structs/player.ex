defmodule CoopGame.Structs.Player do
  @moduledoc false

  alias CoopGame.Structs.Character

  defstruct [
    name: "",
    token: 0,
    joined_room: 0,
    character: %Character{}
  ]
end
