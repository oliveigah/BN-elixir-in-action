defmodule Todo.Database do
  @workers_count 3
  @db_folder "./persist/todo_lists"

  @spec start_link() :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    IO.puts("Starting Todo.Database Supervisor linked to #{inspect(self())}")
    children = Enum.map(1..@workers_count, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp worker_spec(worker_id) do
    default_spec = {Database.Worker, {@db_folder, worker_id}}
    Supervisor.child_spec(default_spec, id: worker_id)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def store(key, value) do
    key
    |> choose_worker()
    |> Database.Worker.store(key, value)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Database.Worker.get(key)
  end

  @spec choose_worker(any) :: any
  defp choose_worker(key) do
    :erlang.phash2(key, @workers_count) + 1
  end
end
