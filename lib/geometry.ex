defmodule Geometry do
  @moduledoc """
    Documentation for 'Geometry'.

    Contains the documentation for geometries modules used in the book Elixir in Action 2nd Edition
  """

  @doc """
  Calculate the area of a rectangle

  Book section: 2.3.1

  This exercise explains the creation and use of a function

  ## Examples

      iex> Geometry.rectangle_area(3,2)
      6

      iex> Geometry.rectangle_area(1,7)
      7
  """

  @spec rectangle_area(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  def rectangle_area(a, b) do
    a * b
  end

  @spec square_area(non_neg_integer) :: non_neg_integer
  @doc """

  Calculate the area of a square

  Book section: 2.3.3

  This exercise explains the usual pattern that low arity delegates to higher arity functions with some default argument values

  In this case, a square is a subset of rectangles so the area function can be implemented as a rectangle area call with both parameters having equal values

  ## Examples

      iex> Geometry.square_area(3)
      9

      iex> Geometry.square_area(7)
      49
  """
  def square_area(a) do
    rectangle_area(a, a)
  end
end
