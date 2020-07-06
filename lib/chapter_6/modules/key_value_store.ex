defmodule Chapter6.KeyValueStore do
  def start do
    Chapter6.ServerProcess.start(Chapter6.KeyValueStore)
  end

  def put(pid, key, value) do
    Chapter6.ServerProcess.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    Chapter6.ServerProcess.call(pid, {:get, key})
  end

  def init do
    %{}
  end

  def handle_cast({:put, key, value}, state) do
    Map.put(state, key, value)
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end
end
