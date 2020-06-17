defmodule Chapter3.FileHelper do
  @moduledoc """
    This module explain how to use high-order functions (Enum and Stream) to iterate over enumerables

    Book section: 3.4
  """

  @spec large_lines!(String.t()) :: [String.t()]
  @doc """
  Get just the lines above 80 characters from a file

  Book section: 3.4.5

  ## Examples
      iex> Chapter3.FileHelper.large_lines!("./test/.resources/text_file.txt")
      ["this is a very very very very very very very very very very very very very long line"]
  """
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  @spec lines_lengths!(String.t()) :: [non_neg_integer()]
  @doc """
  Get the lines length of a file

  Book section: 3.4.5

  ## Examples
      iex> Chapter3.FileHelper.lines_lengths!("./test/.resources/text_file.txt")
      [1,3,5,7,9,84,35,23]
  """
  def lines_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.length/1)
  end

  @spec longest_line_length!(String.t()) :: non_neg_integer()
  @doc """
  Get the longest line length of a file

  Book section: 3.4.5

  ## Examples
      iex> Chapter3.FileHelper.longest_line_length!("./test/.resources/text_file.txt")
      84
  """
  def longest_line_length!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  @spec longest_line!(String.t()) :: String.t()
  @doc """
  Get the longest line of a file

  Book section: 3.4.5

  ## Examples
      iex> Chapter3.FileHelper.longest_line!("./test/.resources/text_file.txt")
      "this is a very very very very very very very very very very very very very long line"
  """
  def longest_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.max_by(&String.length/1)
  end

  @spec words_per_line!(String.t()) :: [non_neg_integer()]
  @doc """
  Get the the number of words per line of a file

  Book section: 3.4.5

  ## Examples
      iex> Chapter3.FileHelper.words_per_line!("./test/.resources/text_file.txt")
      [1,2,3,4,5,18,18,12]
  """
  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, " "))
    |> Enum.map(&length/1)
  end
end
