defmodule Todo.List do
  @type t() :: %Todo.List{auto_id: number(), entries: map()}
  defstruct auto_id: 1, entries: %{}

  @spec new :: Todo.List.t()
  def new() do
    %Todo.List{}
  end

  @spec new([Todo.Entry.t()]) :: Todo.List.t()
  def new(entries) do
    Enum.reduce(entries, %Todo.List{}, &add_entry(&2, &1))
  end

  @spec add_entry(Todo.List.t(), Todo.Entry.t()) :: Todo.List.t()
  def add_entry(todo_list, %Todo.Entry{} = new_entry) do
    entry = Map.put(new_entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %Todo.List{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  @spec entries(Todo.List.t(), Date.t()) :: [Todo.Entry.t()]
  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  @spec update_entry(Todo.List.t(), number(), fun()) :: Todo.List.t()
  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %Todo.Entry{} = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  @spec update_entry(Todo.List.t(), Todo.Entry.t()) :: Todo.List.t()
  def update_entry(todo_list, %Todo.Entry{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list, entry_id) do
    new_entries = Map.delete(todo_list.entries, entry_id)
    %Todo.List{todo_list | entries: new_entries}
  end
end

defmodule Todo.List.CsvImporter do
  defp csv_line_parser(line) do
    [date_string, description] = String.split(line, ",")
    parsed_date = parse_date_to_tuple(date_string)
    %{date: parsed_date, description: description}
  end

  defp parse_date_to_tuple(date_string) do
    date_string
    |> String.split("/")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def import!(csvPath) do
    csvPath
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&csv_line_parser/1)
    |> Todo.List.new()
  end
end

defimpl String.Chars, for: Todo.List do
  def to_string(todo_list) do
    "You have #{todo_list.auto_id - 1} tasks to do"
  end
end

defimpl Collectable, for: Todo.List do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    Todo.List.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done) do
    todo_list
  end

  defp into_callback(_, :halt) do
    :ok
  end
end
