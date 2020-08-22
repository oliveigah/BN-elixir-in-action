defmodule Todo.Entry do
  @type t() :: %Todo.Entry{date: Date.t(), description: String.t()}
  defstruct date: ~D[1995-09-12], description: "No description"

  @spec new(Date.t(), String.t()) :: Todo.Entry.t()
  def new(date, description) do
    %Todo.Entry{date: date, description: description}
  end

  def update_description(%Todo.Entry{} = entry, new_description) do
    %Todo.Entry{entry | description: new_description}
  end
end
