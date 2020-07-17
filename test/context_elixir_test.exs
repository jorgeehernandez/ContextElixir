defmodule ContextElixirTest do
  use ExUnit.Case
  doctest ContextElixir

  test "greets the world" do
    assert ContextElixir.hello() == :world
  end
end
