defmodule Todo.CacheTest do
  use ExUnit.Case
  doctest Todo.Cache

  test "server_process" do
    bob_pid = Todo.Cache.server_process("bob")

    assert bob_pid != Todo.Cache.server_process("alice")
    assert bob_pid == Todo.Cache.server_process("bob")
  end

  test "to-do operations" do
    Todo.Cache.server_process("bob")
    Todo.Server.add_entry("bob", Todo.Entry.new(~D[1995-09-12], "Bob's birthday"))
    entries = Todo.Server.entries("bob", ~D[1995-09-12])

    assert [%Todo.Entry{date: ~D[1995-09-12], description: "Bob's birthday"}] = entries
  end
end
