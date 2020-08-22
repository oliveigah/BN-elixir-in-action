defmodule GeometryTest2 do
  use ExUnit.Case
  doctest Chapter2.Geometry

  test "Rectangle 3 x 3" do
    assert Chapter2.Geometry.rectangle_area(3, 3) == 9
  end

  test "Square 1x1" do
    assert Chapter2.Geometry.square_area(1) == 1
  end
end
