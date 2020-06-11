defmodule GenericTest do
  use ExUnit.Case
  doctest Generic

  test "greets the world" do
    assert Generic.hello() == :world
  end
end
