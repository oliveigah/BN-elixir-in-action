defmodule Chapter6.MyStackServer do
  @moduledoc """
    This is a concrete test module built to test the `Chapter6.MyServerProcess` generic module
  """

  @doc false
  def start do
    Chapter6.MyServerProcess.start(Chapter6.MyStackServer)
  end

  @doc """
  Asynchronously add a value to the stack

  ## Examples
      iex> pid = Chapter6.MyStackServer.start()
      iex> Chapter6.MyStackServer.put(pid, "first")
      iex> Chapter6.MyStackServer.get(pid)
      "first"

      iex> pid = Chapter6.MyStackServer.start()
      iex> Chapter6.MyStackServer.put(pid, "first")
      iex> Chapter6.MyStackServer.put(pid, "second")
      iex> Chapter6.MyStackServer.get(pid)
      "second"
  """
  def put(pid, value) do
    Chapter6.MyServerProcess.cast(pid, {:put, value})
  end

  @doc """
  Synchronously retrieve the first element of the stack
  ## Examples
      iex> pid = Chapter6.MyStackServer.start()
      iex> Chapter6.MyStackServer.get(pid)
      :stack_is_empty

      iex> pid = Chapter6.MyStackServer.start()
      iex> Chapter6.MyStackServer.put(pid, "first")
      iex> Chapter6.MyStackServer.put(pid, "second")
      iex> Chapter6.MyStackServer.get(pid)
      "second"
  """
  def get(pid) do
    Chapter6.MyServerProcess.call(pid, {:get})
  end

  @doc false
  def init do
    []
  end

  @spec handle_cast({:put, any}, list()) :: nonempty_maybe_improper_list
  @doc """
  Handle an async put message

  ## Examples
      iex> Chapter6.MyStackServer.handle_cast({:put,"value"}, [])
      ["value"]

      iex> Chapter6.MyStackServer.handle_cast({:put,"value 3"}, ["value 2" | ["value 1"]])
      ["value 3" | ["value 2", "value 1"]]
  """
  def handle_cast({:put, value}, state) do
    [value | state]
  end

  @spec handle_call({:get}, any()) :: {any, any}
  @doc """
  Handle a sync get message

  ## Examples
      iex> Chapter6.MyStackServer.handle_call({:get}, ["value 2" | ["value 1"]])
      {"value 2", ["value 1" | []]}

      iex> Chapter6.MyStackServer.handle_call({:get}, ["value 3" | ["value 2" , "value 1"]])
      {"value 3", ["value 2" | ["value 1"]]}
  """
  def handle_call({:get}, [head | tail]) do
    {head, tail}
  end

  @doc """
  Handle a sync get message

  ## Examples
      iex> Chapter6.MyStackServer.handle_call({:get}, [])
      {:stack_is_empty, []}
  """
  def handle_call({:get}, head) do
    {:stack_is_empty, head}
  end
end
