defmodule Chapter9.EchoServer do
  use GenServer

  @moduledoc """
  This module explains how to use via tuples patten to create named servers dynamically using the `Registry` module

  - Because this method relies on `Registry` the server is empowered by the benefits of the `Registry` module such as the capability of register and lookup for dynamically generated processes id's
  Book section: 9.1
  """

  def init(_) do
    {:ok, nil}
  end

  def start_link(id) do
    Registry.start_link(name: :my_registry, keys: :unique)
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  def send(id, message) do
    GenServer.call(via_tuple(id), message)
  end

  @doc """
  The via_tuple function is used to retrieve a process identifier on the `Registry` server  using just the `Chapter9.EchoServer` server process identifier
  """
  def via_tuple(id) do
    {:via, Registry, {:my_registry, {__MODULE__, id}}}
  end

  def handle_call(some_request, _from, state) do
    {:reply, some_request, state}
  end
end
