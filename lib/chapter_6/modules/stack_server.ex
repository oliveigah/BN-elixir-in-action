defmodule Chapter6.StackServer do
  @moduledoc """
    This is a concrete test module built to test the `Chapter6.ServerProcess` generic module
  """

  @doc false
  def start do
    Chapter6.ServerProcess.start(Chapter6.StackServer)
  end

  @doc """
  Asynchronously add a value to the stack

  ## Examples
      iex> pid = Chapter6.StackServer.start()
      iex> Chapter6.StackServer.put(pid, "first")
      iex> Chapter6.StackServer.get(pid)
      "first"

      iex> pid = Chapter6.StackServer.start()
      iex> Chapter6.StackServer.put(pid, "first")
      iex> Chapter6.StackServer.put(pid, "second")
      iex> Chapter6.StackServer.get(pid)
      "second"
  """
  def put(pid, value) do
    Chapter6.ServerProcess.cast(pid, {:put, value})
  end

  @doc """
  Synchronously retrieve the first element of the stack
  ## Examples
      iex> pid = Chapter6.StackServer.start()
      iex> Chapter6.StackServer.get(pid)
      :stack_is_empty

      iex> pid = Chapter6.StackServer.start()
      iex> Chapter6.StackServer.put(pid, "first")
      iex> Chapter6.StackServer.put(pid, "second")
      iex> Chapter6.StackServer.get(pid)
      "second"
  """
  def get(pid) do
    Chapter6.ServerProcess.call(pid, {:get})
  end

  @doc false
  def init do
    []
  end

  @spec handle_cast({:put, any}, list()) :: nonempty_maybe_improper_list
  @doc """
  Handle an async put message

  ## Examples
      iex> Chapter6.StackServer.handle_cast({:put,"value"}, [])
      ["value"]

      iex> Chapter6.StackServer.handle_cast({:put,"value 3"}, ["value 2" | ["value 1"]])
      ["value 3" | ["value 2", "value 1"]]
  """
  def handle_cast({:put, value}, state) do
    [value | state]
  end

  @spec handle_call({:get}, any()) :: {any, any}
  @doc """
  Handle a sync get message

  ## Examples
      iex> Chapter6.StackServer.handle_call({:get}, ["value 2" | ["value 1"]])
      {"value 2", ["value 1" | []]}

      iex> Chapter6.StackServer.handle_call({:get}, ["value 3" | ["value 2" , "value 1"]])
      {"value 3", ["value 2" | ["value 1"]]}
  """
  def handle_call({:get}, [head | tail]) do
    {head, tail}
  end

  @doc """
  Handle a sync get message

  ## Examples
      iex> Chapter6.StackServer.handle_call({:get}, [])
      {:stack_is_empty, []}
  """
  def handle_call({:get}, head) do
    {:stack_is_empty, head}
  end
end
