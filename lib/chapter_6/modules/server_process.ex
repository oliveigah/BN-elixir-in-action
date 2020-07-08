defmodule Chapter6.ServerProcess do
  @moduledoc """
    This module explains how to build a generic server process that abstracts implementation details to build a server process
    - A concrete module will be provided by dependency injection to fill the specific implementation but all the flow of control will be managed by this process
    - This helps the concrete modules to be focused on the implementation details of what is relevant for it, making it more clean and easy to understand
    - To this method work, the concrete module has to implement a well defined set of functions very similar to a interface in OO

    Book section: 6.1
  """
  @spec start(module()) :: pid
  @doc """
  Starts the injected module as a server process

  - The injected module must implement `init/0` function, that return the initial state of the server process
  - The injected module is passed as parameter to the `loop/2` function

  Book section: 6.1.1

  ## Examples
      iex> pid = Chapter6.ServerProcess.start(Chapter6.StackServer)
      iex> is_pid(pid)
      true
  """
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  @spec call(pid, any) :: any
  @doc """
  Make a call to the server process and await for it response

  - This function will handle all the requests to the concrete server that the client want to know the result
  - The concrete function must call this function always that a interface function should run synchronously. eg.[this function](Chapter6.StackServer.html#get/1)

  Book section: 6.1.2

  ## Examples
    iex> pid = Chapter6.StackServer.start()
    iex> Chapter6.StackServer.put(pid, "first")
    iex> Chapter6.ServerProcess.call(pid, {:get})
    "first"

    iex> pid = Chapter6.StackServer.start()
    iex> Chapter6.ServerProcess.call(pid, {:get})
    :stack_is_empty
  """
  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  @spec cast(pid, any) :: any
  @doc """
  Make a call to the server process and do not wait for it response

  - This function will handle all the requests to the concrete server that the client do not want to know the result
  - The concrete function must call this function always that a interface function should run asynchronously. eg.[this function](Chapter6.StackServer.html#put/2)

  Book section: 6.1.4

  ## Examples
    iex> pid = Chapter6.StackServer.start()
    iex> Chapter6.ServerProcess.cast(pid, {:put, "first"})
    {:cast, {:put, "first"}}
  """
  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)
        loop(callback_module, new_state)
    end
  end
end
