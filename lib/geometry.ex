defmodule Geometry do
  @moduledoc """
    Documentation for 'Geometry'.

    Contains the documentation for geometries modules used in the book Elixir in Action
  """

  @doc """
  Calculate the area of a rectangle

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
end
