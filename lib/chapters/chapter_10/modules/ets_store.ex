defmodule Chapter10.EtsKeyValue do
  use GenServer
  @moduledoc """
    This module explains how to use ETS table as a key/value store

    - Diferent from the usual key value store implemented with a map, where puts and gets are calls handled by the server, on ETS puts and gets are executed on the client side

    Book section: 10.3
  """

  def init(_) do
    IO.puts(inspect(__MODULE__))

    :ets.new(
      __MODULE__,
      [:named_table, :public, write_concurrency: true]
    )

    {:ok, nil}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end
end
