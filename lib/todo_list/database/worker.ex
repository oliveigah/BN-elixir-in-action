defmodule Database.Worker do
  use GenServer

  @spec start_link({String.t(), number()}) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(folder_path) do
    IO.puts("Starting Database.Worker linked to #{inspect(self())}")

    GenServer.start_link(Database.Worker, folder_path)
  end

  @spec store(pid, any, any) :: :ok
  def store(pid, key, data) do
    GenServer.call(pid, {:store, key, data})
  end

  @spec get(pid, any) :: any
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @impl GenServer
  def init(folder_path) do
    File.mkdir_p!(folder_path)
    {:ok, folder_path}
  end

  defp file_name(folder_path, key) do
    Path.join(folder_path, to_string(key))
  end

  @impl GenServer
  def handle_call({:store, key, value}, _from, folder_path) do
    file_name(folder_path, key)
    |> File.write!(:erlang.term_to_binary(value))

    {:reply, :ok, folder_path}
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
