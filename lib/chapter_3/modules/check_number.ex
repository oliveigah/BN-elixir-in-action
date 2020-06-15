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

  @doc """
  Indicates if a number is positive, negative or zero.

  Book section: 3.3.2

  This exercises shows how to use branching with `cond` macro

  ## Examples
      iex> Chapter3.CheckNumber.cond_check(2)
      :positive

      iex> Chapter3.CheckNumber.cond_check(0)
      :zero

      iex> Chapter3.CheckNumber.cond_check(-1)
      :negative
  """
  @spec cond_check(any) :: :negative | :positive | :zero
  def cond_check(number) do
    cond do
      number > 0 and is_number(number) -> :positive
      number < 0 and is_number(number) -> :negative
      number === 0 -> :zero
    end
  end
end
