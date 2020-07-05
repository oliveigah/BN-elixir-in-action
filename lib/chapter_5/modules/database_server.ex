defmodule Chapter5.DatabaseServer do
  @moduledoc """
    This module explains how to build a server process with immutable state and how to interact with it
    - Server process contains 2 types of functions, interfaces and implementations
    - This moule emulate a database server that handle queries executions through a connection established on the process start

    Book section: 5.3
  """
  @spec start :: pid
  @doc """
  Start a new server process to execute a queries
  - This an interface function, this means that this code runs on the client process side
  - To keep the process runing a tail recursion is needed
  - The initial state is initialized here and passes to the loop function

  Book section: 5.3.1 e 5.3.2

  ## Examples
      iex> server_pid = Chapter5.DatabaseServer.start()
      iex> is_pid(server_pid)
      true
  """
  def start do
    spawn(fn ->
      connection = :rand.uniform(1000)
      loop(connection)
    end)
  end

  @spec run_async(pid, String.t()) :: String.t()
  @doc """
  Run a query on a specific database server process
  - This an interface function, this means that this code runs on the client process side
  - The `self()` call here is evaluated with the client pid, because this is an interface function
  - Interface functions abstract the implementation details to use a server process, like here the client do not have to know that to run a query it must send a message taht matchs with it `{:run_query, self(), query_def}`
  - Although the client may know the internal representation of the method, it should not rely on it
  Book section: 5.3.1 e 5.3.2

  ## Examples
      iex> server_pid = Chapter5.DatabaseServer.start()
      iex> client_pid = self()
      iex> result = Chapter5.DatabaseServer.run_async(server_pid, "query 1")
      iex> {:run_query, ^client_pid, "query 1"} = result

  """
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  @spec get_result :: {:error, :timeout} | {:ok, String.t()}
  @doc """
  Get the oldest query result that was executed by a `Chapter5.DatabaseServer` server process
  - This an interface function, this means that this code runs on the client process side
  - The `self()` call here is evaluated with the client pid, because this is an interface function
  - Interface functions abstract the implementation details to use a server process, like here the client do not have to know that messages from the server process are sent matching this pattern `{:query_result, result}`

  Book section: 5.3.1 e 5.3.2

  ## Examples
      iex> server_pid = Chapter5.DatabaseServer.start()
      iex> Chapter5.DatabaseServer.run_async(server_pid, "query 1")
      iex> result = Chapter5.DatabaseServer.get_result()
      iex> compare_result = String.split(result,":")
      iex> List.last(compare_result)
      "query 1 result"
  """
  def get_result do
    receive do
      {:query_result, result} ->
        result
    after
      5000 -> {:error, :timeout}
    end
  end

  defp run_query(connection, query_def) do
    Process.sleep(2000)
    "Connection #{connection}:#{query_def} result"
  end

  @doc """
  This is the tail recursion used to keep the server process runing
  - This an implementation function, this means that this code runs on the server process side
  - Pattern matching is used to filter the incoming messages
  - Then a message is sent to the caller with the result of the computation done
  - Implementation functions usually are private but for documentation purpose they are pulic here
  - The initial state is passed as parameter to the next loop iteration

  Book section: 5.3.1 e 5.3.2

  ## Examples
      iex> server_pid = Chapter5.DatabaseServer.start()
      iex> is_pid(server_pid)
      true
  """
  def loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(connection, query_def)})
    end

    loop(connection)
  end
end
