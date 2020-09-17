defmodule Todo.Cache do
  def init(_args) do
    {:ok, %{}}
  end

  def start_link() do
    IO.puts("Starting Todo.Cache linked to #{inspect(self())}")
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(__MODULE__, {Todo.Server, todo_list_name})
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def server_process(todo_list_name) do
    :rpc.call(
      Todo.Server.find_node(todo_list_name),
      __MODULE__,
      :run_server_process,
      [todo_list_name]
    )
  end

  def run_server_process(todo_list_name) do
    case start_child(todo_list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
