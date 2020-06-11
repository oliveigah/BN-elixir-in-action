defmodule GeometryTest do
  use ExUnit.Case
  doctest Geometry

  test "Rectangle 3 x 3" do
    assert Geometry.rectangle_area(3, 3) == 9
  end

  test "Square 1x1" do
    assert Geometry.square_area(1) == 1
  end
end
