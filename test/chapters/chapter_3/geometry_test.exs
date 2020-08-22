defmodule GeometryTest3 do
  use ExUnit.Case
  doctest Chapter3.Geometry

  test "Rectangle 3 x 8" do
    assert Chapter3.Geometry.area({:rectangle, 3, 8}) == 24
  end

  test "Square 2 x 2" do
    assert Chapter3.Geometry.area({:square, 2}) == 4
  end

  test "Circle radius 1" do
    assert Chapter3.Geometry.area({:circle, 1})
           |> Float.round(2) == 3.14
  end
end
