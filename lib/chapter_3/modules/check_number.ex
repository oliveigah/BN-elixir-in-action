defmodule Chapter3.CheckNumber do
  @moduledoc """
    This module explain how guards work on multi-clauses functions.

    Book section: 3.2
  """

  @doc """
  Indicates if a number is positive, negative or zero.

  Book section: 3.2.2

  This exercises shows how to use guards on multi-clauses functions to achieve "if like" behaviours

  ## Examples
      iex> Chapter3.CheckNumber.check(2)
      :positive

      iex> Chapter3.CheckNumber.check(0)
      :zero

      iex> Chapter3.CheckNumber.check(-1)
      :negative
  """
  @spec check(number) :: :negative | :positive | :zero
  def check(number) when is_number(number) and number < 0 do
    :negative
  end

  def check(0) do
    :zero
  end

  def check(number) when is_number(number) and number > 0 do
    :positive
  end
end
