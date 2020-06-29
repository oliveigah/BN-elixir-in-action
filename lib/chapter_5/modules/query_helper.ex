defmodule Chapter5.QueryHelper do
  @moduledoc """
    This module explains how to spawn a new process and receive messages from it

    Book section: 5.2
  """

  @spec execute_query_on_another_process(String.t()) :: pid
  @doc """
  Spawn a new process to executes a query
  - `self/1` is used to get the caller pid wich will be send to the new process
  - `self/1` can should not be called inside the `spawn/1` function
  - A deep copy of every data passed to `spawn/1` is send to the new process

  Book section: 5.2.1

  ## Examples
      iex> is_pid(Chapter5.QueryHelper.execute_query_on_another_process("query"))
      true
  """
  def execute_query_on_another_process(query_text) do
    caller = self()
    spawn(fn -> send(caller, {:query_result, execute_query(query_text)}) end)
  end

  @spec execute_query(String.t()) :: <<_::56, _::_*8>>
  @doc """
  Simulate a database call with 2 seconds delay

  Book section: 5.2.1
  """
  def execute_query(query_text) do
    Process.sleep(2000)
    "#{query_text} result"
  end

  @spec run_queries_sync(list()) :: list()
  @doc """
  Run a list of queries synchronously
  - This function takes `2 * length(list)` seconds to execute

  Book section: 5.2.1

  ## Examples
      iex> Chapter5.QueryHelper.run_queries_sync(["query1", "query2"])
      ["query1 result", "query2 result"]

      iex> Chapter5.QueryHelper.run_queries_sync([])
      []
  """
  def run_queries_sync(queries_list) do
    Enum.map(queries_list, &execute_query/1)
  end

  @spec run_queries_async(list()) :: [pid()]
  @doc """
  Run a list of queries asynchronously
  - This function always takes 2 seconds to execute
  - Although, it does not return the queries results, it returns a list of pids

  Book section: 5.2.2

  ## Examples
      iex> Enum.map(Chapter5.QueryHelper.run_queries_async(["query1", "query2"]), &is_pid/1)
      [true, true]

      iex> Chapter5.QueryHelper.run_queries_async([])
      []
  """
  def run_queries_async(queries_list) do
    Enum.map(queries_list, &execute_query_on_another_process/1)
  end

  @doc """
  Get the first query result from the process inbox
  - This function relies on patten matching to distinguish between query result messages and other possible messages on the inbox
  - To prevent being stuck if no message has arrived, the clause `after` is used. Kind of a timeout

  Book section: 5.2.2

  ## Examples
      iex> Chapter5.QueryHelper.run_queries_async(["query1"])
      iex> Chapter5.QueryHelper.get_some_result_from_inbox()
      "query1 result"

  """
  def get_some_result_from_inbox() do
    receive do
      {:query_result, result} -> result
    after
      5000 -> "No query result message received"
    end
  end
end
