defmodule Todo.Server do
  use GenServer, restart: :temporary

  @idle_timeout :timer.seconds(10)

  @spec start(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start(todo_list_name) do
    GenServer.start(Todo.Server, todo_list_name)
  end

  @spec start_link(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(todo_list_name) do
    GenServer.start_link(Todo.Server, todo_list_name, name: via_tuple(todo_list_name))
  end

  defp via_tuple(todo_list_name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, todo_list_name})
  end

  @impl GenServer
  def init(list_name) do
    send(self(), {:real_init, list_name})
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:real_init, list_name}, _state) do
    {:noreply, {list_name, Todo.Database.get(list_name) || Todo.List.new()}, @idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {list_name, %Todo.List{} = todo_list}) do
    {:stop, :normal, {list_name, todo_list}}
  end

  @spec add_entry(String.t(), Todo.Entry.t()) :: any
  def add_entry(todo_list_name, %Todo.Entry{} = entry) do
    GenServer.cast(via_tuple(todo_list_name), {:add_entry, entry})
  end

  @spec entries(String.t(), Date.t()) :: [Todo.Entry.t()]
  def entries(todo_list_name, date) do
    GenServer.call(via_tuple(todo_list_name), {:get_entries, date})
  end

  @spec update_entry(String.t(), Todo.Entry.t()) :: any()
  def update_entry(todo_list_name, %Todo.Entry{} = new_entry) do
    GenServer.cast(via_tuple(todo_list_name), {:update_entry, new_entry})
  end

  @spec update_entry(String.t(), number(), fun()) :: any()
  def update_entry(todo_list_name, entry_id, update_fun) do
    GenServer.cast(via_tuple(todo_list_name), {:update_entry, entry_id, update_fun})
  end

  @spec delete_entry(String.t(), number()) :: any
  def delete_entry(todo_list_name, entry_id) do
    GenServer.cast(via_tuple(todo_list_name), {:delete_entry, entry_id})
  end

  @impl GenServer
  def handle_call({:get_entries, date}, _from, {_list_name, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state, @idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add_entry, %Todo.Entry{} = entry}, {list_name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:update_entry, new_entry}, {list_name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, new_entry)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:update_entry, entry_id, update_fun}, {list_name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, update_fun)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end

  def handle_cast({:delete_entry, entry_id}, {list_name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}, @idle_timeout}
  end
end
