defmodule Database.Worker do
  use GenServer

  @spec start_link({String.t(), number()}) :: :ignore | {:error, any} | {:ok, pid}
  def start_link({folder_path, worker_id}) do
    IO.puts("Starting Database.Worker #{inspect(worker_id)} linked to #{inspect(self())}")

    GenServer.start_link(
      Database.Worker,
      folder_path,
      name: via_tuple(worker_id)
    )
  end

  @spec store(number, any, any) :: :ok
  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  @spec get(number, any) :: any
  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def init(folder_path) do
    File.mkdir_p!(folder_path)
    {:ok, folder_path}
  end

  defp file_name(folder_path, key) do
    Path.join(folder_path, to_string(key))
  end

  defp via_tuple(worker_id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end

  def handle_cast({:store, key, value}, folder_path) do
    file_name(folder_path, key)
    |> File.write!(:erlang.term_to_binary(value))

    {:noreply, folder_path}
  end

  def handle_call({:get, key}, _from, folder_path) do
    response =
      case File.read(file_name(folder_path, key)) do
        {:ok, data} -> :erlang.binary_to_term(data)
        _ -> nil
      end

    {:reply, response, folder_path}
  end
end
