defmodule CoopGameTest do
  use ExUnit.Case
  doctest CoopGame

  test "greets the world" do
    assert CoopGame.hello() == :world
  end
end
