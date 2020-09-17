defmodule Todo.Database do
  @workers_count 3
  @db_folder "./persist/todo_lists"

  def child_spec(_) do
    File.mkdir(@db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Database.Worker,
        size: @workers_count
      ],
      ["#{@db_folder}/#{node()}"]
    )
  end

  def store_local(key, value) do
    :poolboy.transaction(__MODULE__, fn worker_pid ->
      Database.Worker.store(worker_pid, key, value)
    end)
  end

  def store(key, value) do
    {_results, fail_nodes} =
      :rpc.multicall(
        __MODULE__,
        :store_local,
        [key, value],
        :timer.seconds(5)
      )

    Enum.each(fail_nodes, &IO.puts("Store failed on node #{&1}"))

    :ok
  end

  @spec get(any) :: any
  def get(key) do
    :poolboy.transaction(__MODULE__, fn worker_pid ->
      Database.Worker.get(worker_pid, key)
    end)
  end
end
