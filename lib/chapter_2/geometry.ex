defmodule Geometry do
  @moduledoc """
    Documentation for 'Geometry'.

    Contains the documentation for geometries modules used in the book Elixir in Action 2nd Edition
  """
  @pi 3.14159

  @spec multiply(number(), number()) :: number()
  defp multiply(a, b) do
    a * b
  end

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
    multiply(a, b)
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

  @doc """

  Calculate the area of a circle

  Book section: 2.3.6

  This exercise explains the usage of module attributes and how to combine functions in docTests. In this case I'm using @pi as a module attribute

  ## Examples

      iex> Geometry.circle_area(3) |> Float.round(2)
      28.27
  """
  @spec circle_area(number()) :: float
  def circle_area(r), do: r * r * @pi

  @doc """

  Calculate the circunference of a circle

  Book section: 2.3.6

  This exercise explains the usage of module attributes and how to combine functions in docTests. In this case I'm using @pi as a module attribute

  ## Examples

      iex> Geometry.circle_circunference(3) |> Float.round(2)
      18.85
  """
  @spec circle_circunference(number) :: float
  def circle_circunference(r), do: 2 * r * @pi
end
