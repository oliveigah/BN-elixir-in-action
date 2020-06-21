defmodule Chapter4.Fraction do
  @moduledoc """
    This module explains how to use `struct` and apply pattern matching with it

    Book Section 4.1
  """
  @type fraction() :: %Chapter4.Fraction{}
  defstruct numerator: nil, denominator: nil

  @spec new(integer(), integer()) :: Chapter4.Fraction.fraction()
  @doc """
  Create a new fraction data abstraction

  Book section: 4.1.4

  This function shows how to build constructors-like behaviour on elixir

  ## Examples
      iex> Chapter4.Fraction.new(1,2)
      %Chapter4.Fraction{numerator: 1, denominator: 2}

      iex> Chapter4.Fraction.new(5,3)
      %Chapter4.Fraction{numerator: 5, denominator: 3}
  """
  def new(numerator, denominator) do
    %Chapter4.Fraction{numerator: numerator, denominator: denominator}
  end

  @spec value(Chapter4.Fraction.fraction()) :: float
  @doc """
  Get the float equivalent value of a fraction

  Book section: 4.1.4

  This function shows how to use pattern matching with structs

  ## Examples
      iex> Chapter4.Fraction.new(1,2) |> Chapter4.Fraction.value()
      0.5

      iex> Chapter4.Fraction.value(%Chapter4.Fraction{numerator: 3, denominator: 4})
      0.75
  """
  def value(%Chapter4.Fraction{numerator: num, denominator: den}) do
    num / den
  end

  @spec add(Chapter4.Fraction.fraction(), Chapter4.Fraction.fraction()) ::
          Chapter4.Fraction.fraction()
  @doc """
  Add two fractions and return the result

  Book section: 4.1.4

  This function shows how to use pattern matching with structs

  ## Examples
      iex> Chapter4.Fraction.add(Chapter4.Fraction.new(1,2), Chapter4.Fraction.new(1,4))
      %Chapter4.Fraction{numerator: 6, denominator: 8}

      iex> Chapter4.Fraction.add(Chapter4.Fraction.new(3,2), Chapter4.Fraction.new(1,4))
      %Chapter4.Fraction{numerator: 14, denominator: 8}
  """
  def add(
        %Chapter4.Fraction{numerator: num1, denominator: den1},
        %Chapter4.Fraction{numerator: num2, denominator: den2}
      ) do
    new_numerator = num1 * den2 + num2 * den1
    new_denominator = den1 * den2
    new(new_numerator, new_denominator)
  end
end
