defmodule Chapter3.Geometry do
  @moduledoc """
    This module explain how multi-clauses functions works.

    Book section: 3.2
  """
  @pi 3.14159

  @doc """
  Calculate the area of a geometric shape.

  Book section: 3.2.1

  This exercises shows how to build multi-clauses functions, in this case the function area has 3 distincts implementations depends on clause that is successful matchs at runtime.

  The pinpoint of this is the pattern matching explained on [this section](chapter_3.html#3-1-pattern-matching).

  ## Examples
      iex> Chapter3.Geometry.area({:rectangle, 3, 7})
      21

      iex> Chapter3.Geometry.area({:square, 3})
      9

      iex> Chapter3.Geometry.area({:circle, 3}) |> Float.round(2)
      28.27
  """
  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * a
  end

  def area({:circle, r}) do
    r * r * @pi
  end

  def area(shape) do
    {:error, {:unknown_shape, shape}}
  end
end
