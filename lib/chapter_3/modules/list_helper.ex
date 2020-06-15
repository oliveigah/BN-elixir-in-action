defmodule Chapter3.ListHelper do
  @moduledoc """
    This module explain how patter macthing and multiclause functions are powerfull tools to build recursive functions

    Book section: 3.3
  """

  @spec sum(list()) :: number
  @doc """
  Sum all elements on a list

  Book section: 3.3.1

  This exercises shows how to use multiclause functions to build recursive functions more easily

  And shows how to use the list notation of [head | tails]

  ## Examples
      iex> Chapter3.ListHelper.sum([2,3,5,10])
      20

      iex> Chapter3.ListHelper.sum([0,0,33,2,7])
      42

      iex> Chapter3.ListHelper.sum([])
      0
  """
  def sum([]), do: 0

  def sum([head | tail]), do: head + sum(tail)
end
