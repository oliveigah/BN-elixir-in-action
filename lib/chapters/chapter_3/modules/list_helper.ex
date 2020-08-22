defmodule Chapter3.ListHelper do
  @moduledoc """
    This module explains how pattern macthing and multiclause functions are powerfull tools to build recursive functions and how use tail and non-tail recursions to build iterations

    Book section: 3.3 and 3.4
  """

  @spec sum(list()) :: number
  @doc """
  Sum all elements on a list

  Book section: 3.3.1 | 3.4.1

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

  @spec no_tail_len(list()) :: number()

  @doc """
  Get the length of a list using non tail recursive function call

  Book section: 3.4.1

  This exercises shows how to built iterations using recursive functions

  And shows how to use the list notation of [head | tails]

  ## Examples
      iex> Chapter3.ListHelper.no_tail_len([2,3,5,10])
      4

      iex> Chapter3.ListHelper.no_tail_len([0,0,33,2,7])
      5

      iex> Chapter3.ListHelper.no_tail_len([])
      0
  """
  def no_tail_len([]), do: 0

  def no_tail_len([_ | tail]), do: 1 + no_tail_len(tail)

  @spec tail_len(list()) :: number()
  @doc """
  Get the length of a list using tail recursive function call

  Book section: 3.4.2

  This exercises shows how to build iterations using tail recursive functions

  And shows how to use the list notation of [head | tails]

  ## Examples
      iex> Chapter3.ListHelper.tail_len([2,3,5,10])
      4

      iex> Chapter3.ListHelper.tail_len([0,0,33,2,7])
      5

      iex> Chapter3.ListHelper.tail_len([])
      0
  """
  def tail_len(list) do
    do_tail_len(0, list)
  end

  defp do_tail_len(acc, []), do: acc

  defp do_tail_len(acc, [_ | tail]) do
    acc = acc + 1
    do_tail_len(acc, tail)
  end

  @spec non_tail_range(number(), number()) :: list()
  @doc """
  Get a list of integers between 2 numbers using non tail recursive call

  Book section: 3.4.2

  This exercises shows how to build iterations using non tail recursive functions

  ## Examples
      iex> Chapter3.ListHelper.non_tail_range(0,5)
      [0,1,2,3,4,5]

      iex> Chapter3.ListHelper.non_tail_range(7,7)
      [7]

      iex> Chapter3.ListHelper.non_tail_range(7,10)
      [7,8,9,10]
  """
  def non_tail_range(from, to) when to < from do
    []
  end

  def non_tail_range(from, to) do
    [from | non_tail_range(from + 1, to)]
  end

  @spec tail_range(number(), number()) :: list()
  @doc """
  Get a list of integers between 2 numbers using tail recursive call

  Book section: 3.4.2

  This exercises shows how to build iterations using tail recursive functions

  **The logic was made inverse because of performance, since lists are O(1) to insert on the start and O(n) to insert on the end its better to build the list from end to start**

  ## Examples
      iex> Chapter3.ListHelper.tail_range(0,5)
      [0,1,2,3,4,5]

      iex> Chapter3.ListHelper.tail_range(7,7)
      [7]

      iex> Chapter3.ListHelper.tail_range(7,10)
      [7,8,9,10]
  """
  def tail_range(from, to) do
    do_tail_range([], from, to)
  end

  defp do_tail_range(list, from, to) when to < from do
    list
  end

  defp do_tail_range(list, from, to) when to >= from do
    new_list = [to | list]
    do_tail_range(new_list, from, to - 1)
  end

  @spec non_tail_positives(list()) :: list()
  @doc """
  Get a list with just the positives integer on a list using non tail recursive call

  Book section: 3.4.2

  This exercises shows how to build iterations using non tail recursive functions

  ## Examples
      iex> Chapter3.ListHelper.non_tail_positives([0,5,7,-3,8,-2,-1])
      [5,7,8]

      iex> Chapter3.ListHelper.non_tail_positives([3,2,1])
      [3,2,1]

      iex> Chapter3.ListHelper.non_tail_positives([-7,-10])
      []
  """
  def non_tail_positives([]) do
    []
  end

  def non_tail_positives([head | tail]) do
    if head > 0, do: [head | non_tail_positives(tail)], else: non_tail_positives(tail)
  end

  @spec tail_positives(list(number())) :: list(non_neg_integer())
  @doc """
  Get a list with just the positives integer on a list using tail recursive call

  Book section: 3.4.2

  This exercises shows how to build iterations using tail recursive functions

  ## Examples
      iex> Chapter3.ListHelper.tail_positives([0,5,7,-3,8,-2,-1])
      [5,7,8]

      iex> Chapter3.ListHelper.tail_positives([3,2,1])
      [3,2,1]

      iex> Chapter3.ListHelper.tail_positives([-7,-10])
      []
  """
  def tail_positives(list) do
    do_tail_positives([], list)
  end

  defp do_tail_positives(positive_list, []) do
    Enum.reverse(positive_list)
  end

  defp do_tail_positives(positive_list, [rcv_head | rcv_tail]) do
    if rcv_head > 0 do
      new_positive_list = [rcv_head | positive_list]
      do_tail_positives(new_positive_list, rcv_tail)
    else
      do_tail_positives(positive_list, rcv_tail)
    end
  end
end
