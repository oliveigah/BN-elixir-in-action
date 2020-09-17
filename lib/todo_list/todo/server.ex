defmodule Todo.Server do
  use GenServer, restart: :temporary

  @idle_timeout :timer.seconds(240)

  @spec start_link(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(todo_list_name) do
    GenServer.start_link(Todo.Server, todo_list_name, name: via_tuple(todo_list_name))
  end

  defp persist(list_name, todo_list) do
    Todo.Database.store(list_name, todo_list)
  end

  defp via_tuple(todo_list_name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, todo_list_name})
  end

  @impl GenServer
  def init(list_name) do
    send(self(), {:real_init, list_name})
    {:ok, nil}
  end

  def find_node(list_name) do
    nodes = Enum.sort(Node.list([:this, :visible]))

    node_index =
      :erlang.phash2(
        list_name,
        length(nodes)
      )

    Enum.at(nodes, node_index)
  end

  @impl GenServer
  def handle_info({:real_init, list_name}, _state) do
    {:noreply, {list_name, Todo.Database.get(list_name) || Todo.List.new()}, @idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {list_name, %Todo.List{} = todo_list}) do
    {:stop, :normal, {list_name, todo_list}}
  end

  @spec add_entry(pid, Todo.Entry.t()) :: any
  def add_entry(server, %Todo.Entry{} = entry) do
    GenServer.cast(server, {:add_entry, entry})
  end

  @spec entries(pid, Date.t()) :: [Todo.Entry.t()]
  def entries(server, date) do
    GenServer.call(server, {:get_entries, date})
  end

  @spec update_entry(pid, Todo.Entry.t()) :: any()
  def update_entry(server, %Todo.Entry{} = new_entry) do
    GenServer.cast(server, {:update_entry, new_entry})
  end

  @spec update_entry(pid, number(), fun()) :: any()
  def update_entry(server, entry_id, update_fun) do
    GenServer.cast(server, {:update_entry, entry_id, update_fun})
  end

  @spec delete_entry(pid, number()) :: any
  def delete_entry(server, entry_id) do
    GenServer.cast(server, {:delete_entry, entry_id})
  end

  @impl GenServer
  def handle_call({:get_entries, date}, _from, {_list_name, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state, @idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add_entry, %Todo.Entry{} = entry}, {list_name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, entry)
    persist(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:update_entry, new_entry}, {list_name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, new_entry)
    persist(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:update_entry, entry_id, update_fun}, {list_name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, update_fun)
    persist(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:delete_entry, entry_id}, {list_name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    persist(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end
end
