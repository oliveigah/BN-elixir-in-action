defmodule Chapter2.Calculator do
  @moduledoc """
    Documentation for 'Calculator'.

    Contains the documentation for calculator modules used in the book Elixir in Action 2nd Edition
  """

  @doc """
  Sum two numbers

  Book section: 2.3.3

  This exercise explains the usual pattern that low arity delegates to higher arity functions with some default argument values

  ## Examples

      iex> Chapter2.Calculator.sum(1)
      1

      iex> Chapter2.Calculator.sum(1,4)
      5
  """
  @spec sum(number, number) :: number
  def sum(a, b \\ 0) do
    a + b
  end

  @doc """
  Divides a number by the other

  Book section: 2.4.1

  This exercise explains that the '/' operator always returns a float

  ## Examples

      iex> Chapter2.Calculator.division(1,1)
      1.0

      iex> Chapter2.Calculator.division(1,4)
      0.25
  """
  @spec division(number, number) :: float
  def division(a, b) do
    a / b
  end

  @doc """
  Gets the integer part of a division

  Book section: 2.4.1

  This exercise explains how to use the kernel function div

  ## Examples

      iex> Chapter2.Calculator.integer_of_div(1,1)
      1

      iex> Chapter2.Calculator.integer_of_div(5,2)
      2
  """
  @spec integer_of_div(integer, integer) :: integer
  def integer_of_div(a, b) do
    div(a, b)
  end

  @doc """
  Gets the remainder part of a division

  Book section: 2.4.1

  This exercise explains how to use the kernel function rem

  ## Examples

      iex> Chapter2.Calculator.remainder_of_div(1,1)
      0

      iex> Chapter2.Calculator.remainder_of_div(1,4)
      1
  """
  @spec remainder_of_div(integer, integer) :: integer
  def remainder_of_div(a, b) do
    rem(a, b)
  end
end
