defmodule Chapter2.CalculatorTest do
  use ExUnit.Case
  doctest Chapter2.Calculator

  test "1 plus 1" do
    assert Chapter2.Calculator.sum(1, 1) == 2
  end

  test "1 plus 3" do
    assert Chapter2.Calculator.sum(1, 3) == 4
  end

  test "only 3" do
    assert Chapter2.Calculator.sum(3) == 3
  end
end
