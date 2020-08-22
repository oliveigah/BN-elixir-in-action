defmodule GenericTest do
  use ExUnit.Case
  doctest Chapter2.Generic

  test "greets the world" do
    assert Chapter2.Generic.hello() == :world
  end
end
