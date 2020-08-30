defmodule Chapter10.SimpleRegistry do
  use GenServer

  def init(_) do
    :ets.new(
      __MODULE__,
      [:named_table, :public, write_concurrency: true]
    )

    Process.flag(:trap_exit, true)
    {:ok, nil}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(key) do
    Process.link(Process.whereis(__MODULE__))
    :ets.insert_new(__MODULE__, {key, self()})
  end

  def whereis(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  def handle_info({:EXIT, pid, _reason}, _state) do
    :ets.match_delete(__MODULE__, {:_, pid})
    {:noreply, nil}
  end
end
