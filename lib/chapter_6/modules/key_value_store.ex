defmodule Chapter6.KeyValueStore do
  @moduledoc """
    This module explains how to build a concrete module that relies on a generic server implementation
    - The concrete module relies on functions such as `Chapter6.ServerProcess.start/1`, `Chapter6.ServerProcess.cast/2` and `Chapter6.ServerProcess.call/2` to implement a server process with no boilerplate
    - The clarity of the code using a GenServer abstraction is way higher

    Book section: 6.1
  """

  @doc """
  Starts the server process

  - This function relies in `Chapter6.ServerProcess.start/1`

  Book section: 6.1.3

  ## Examples
      iex> pid = Chapter6.KeyValueStore.start()
      iex> is_pid(pid)
      true
  """
  def start do
    Chapter6.ServerProcess.start(Chapter6.KeyValueStore)
  end

  @spec put(pid, any, any) :: any
  @doc """
  Add a key/value pair asynchronously

  - If a function should be running asynchronously, it must use the `Chapter6.ServerProcess.cast/2` function

  Book section: 6.1.3

  ## Examples
      iex> pid = Chapter6.KeyValueStore.start()
      iex> Chapter6.KeyValueStore.put(pid, :first, "value")
      iex> Chapter6.KeyValueStore.get(pid, :first)
      "value"
  """
  def put(pid, key, value) do
    Chapter6.ServerProcess.cast(pid, {:put, key, value})
  end

  @spec get(pid, any) :: any
  @doc """
  Get the value referenced by a specific key synchronously

  - If a function should be running synchronously, it must use the `Chapter6.ServerProcess.call/2` function

  Book section: 6.1.3

  ## Examples
      iex> pid = Chapter6.KeyValueStore.start()
      iex> Chapter6.KeyValueStore.put(pid, :first, "value")
      iex> Chapter6.KeyValueStore.get(pid, :first)
      "value"
  """
  def get(pid, key) do
    Chapter6.ServerProcess.call(pid, {:get, key})
  end

  @spec init :: %{}
  @doc """
  Return the initial state of the server

  - This function is used inside the `Chapter6.ServerProcess.start/1` implementation to set the initial state of the server process

  Book section: 6.1.3

  ## Examples
      iex> pid = Chapter6.KeyValueStore.init()
      %{}
  """
  def init do
    %{}
  end

  @spec handle_cast({:put, any, any}, map) :: map
  @doc """
  Handle an async put message

  - The return of the handle_cast functions implementations should always be the new state value

  Book section: 6.1.4

  ## Examples
      iex> Chapter6.KeyValueStore.handle_cast({:put, :key, "value"}, %{})
      %{key: "value"}

      iex> Chapter6.KeyValueStore.handle_cast({:put, :key, "value"}, %{other_key: "other_value"})
      %{key: "value", other_key: "other_value"}
  """
  def handle_cast({:put, key, value}, state) do
    Map.put(state, key, value)
  end

  @spec handle_call({:get, any}, map) :: {any, map}
  @doc """
  Handle a sync get message

  - The return of the handle_cast functions implementations should always be in the same format that the abstraction expects `{result, new_state}`

  Book section: 6.1.3

  ## Examples
      iex> Chapter6.KeyValueStore.handle_call({:get, :key} , %{key: "value"})
      {"value", %{key: "value"}}

      iex> Chapter6.KeyValueStore.handle_call({:get, :key} , %{})
      {nil, %{}}
  """
  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end
end
