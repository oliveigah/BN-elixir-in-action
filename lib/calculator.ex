defmodule Calculator do
  @moduledoc """
    Documentation for 'Calculator'.

    Contains the documentation for calculator modules used in the book Elixir in Action 2nd Edition
  """

  @doc """
  Sum two numbers

  Book section: 2.3.3

  This exercise explains the usual pattern that low arity delegates to higher arity functions with some default argument values

  ## Examples

      iex> Calculator.sum(1)
      1

      iex> Calculator.sum(1,4)
      5
  """
  @spec sum(number, number) :: number
  def sum(a, b \\ 0) do
    a + b
  end
end
