defmodule Chapter10.QueryHelper do
  @moduledoc """
    This module explains how to use `Task` abstraction to manage asynchronous tasks. Kind of async/await on JS

    Book section: 10.1
  """

  @doc """
  Simulate a database call with 1 second delay

  Book section: 10.1.1
  """
  def execute_query(query_text) do
    Process.sleep(1000)
    "#{query_text} result"
  end

  @doc """
  This function shows how to use `Task` to initiate concurrent computation

  - Very similar to a `Promise.all` on JS.
  - `Task.async/1` returns a promise that is awaited by `Task.await/1`

  Book section: 10.1.1
  """
  def run_queries(queries_list) do
    Enum.map(queries_list, &Task.async(fn -> execute_query(&1) end))
    |> Enum.map(&Task.await/1)
  end
end
