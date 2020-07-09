defmodule Chapter6.KeyValueStore do
  @moduledoc """
    This module explains how to build a module that relies on `GenServer`
    - The basic approach is similiar to the `Chapter6.MyKeyValueStore`
    - This callback module must implement a set of functions in order to be compatible with `GenServer`

    Book section: 6.2
  """
  use GenServer

  @doc """
  Starts the server process

  - This function relies in `GenServer.start/3`

  Book section: 6.2.2

  ## Examples
      iex> {:ok, pid} = Chapter6.KeyValueStore.start()
      iex> is_pid(pid)
      true
  """
  def start() do
    GenServer.start(Chapter6.KeyValueStore, nil)
  end

  @doc """
  Add a key/value pair asynchronously

  - If a function should be running asynchronously, it must use the `GenServer.cast/2` function

  Book section: 6.2.3

  ## Examples
      iex> {:ok, pid} = Chapter6.KeyValueStore.start()
      iex> Chapter6.KeyValueStore.put(pid, :first, "value")
      iex> Chapter6.KeyValueStore.get(pid, :first)
      "value"
  """
  def put(server_pid, key, value) do
    GenServer.cast(server_pid, {:put, key, value})
  end

  @doc """
  Get the value referenced by a specific key synchronously

  - If a function should be running synchronously, it must use the `GenServer.call/2` function

  Book section: 6.2.3

  ## Examples
      iex> {:ok, pid} = Chapter6.KeyValueStore.start()
      iex> Chapter6.KeyValueStore.put(pid, :first, "value")
      iex> Chapter6.KeyValueStore.get(pid, :first)
      "value"

      iex> {:ok, pid} = Chapter6.KeyValueStore.start()
      iex> Chapter6.KeyValueStore.get(pid, :first)
      nil
  """
  def get(server_pid, key) do
    GenServer.call(server_pid, {:get, key})
  end

  @doc """
  Initialize the server

  - The function `:timer.send_interval` is used to send a periodically request to the server

  Book section: 6.2.4
  """
  @impl GenServer
  def init(_args) do
    :timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  @doc false
  @impl GenServer
  def handle_call({:get, key}, _from, %{} = state) do
    response = Map.get(state, key)
    {:reply, response, state}
  end

  @doc false
  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    new_state = Map.put(state, key, value)
    {:noreply, new_state}
  end

  @impl GenServer
  @doc """
  Handle generic custom calls to the server

  - Any message that arrives to the server that do not fall into one of the 2 categories, cast or call will be handled by this function

  Book section: 6.2.4
  """
  def handle_info(:cleanup, state) do
    IO.puts("performing cleanup...")
    {:noreply, state}
  end
end
