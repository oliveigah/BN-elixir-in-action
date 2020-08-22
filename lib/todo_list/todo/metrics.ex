defmodule Todo.Metrics do
  use Task

  def start_link(_) do
    Task.start_link(&loop/0)
  end

  def loop do
    Process.sleep(:timer.seconds(10))
    Todo.Database.store("metrics", collect_metrics())
    loop()
  end

  defp collect_metrics() do
    current_data = %{} = Todo.Database.get("metrics") || %{}

    cycle_data = %{
      memory_usage: div(:erlang.memory(:total), 1_000_000),
      process_count: :erlang.system_info(:process_count)
    }

    IO.puts(inspect(cycle_data))
    Map.put(current_data, DateTime.utc_now(), cycle_data)
  end
end
