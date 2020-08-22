defmodule Chapter5.Calculator do
  @moduledoc """
    This module explains how to build a server process with mutable state and how to interact with it
    - Server process contains 2 types of functions, interfaces and implementations
    - This module is a calculator server that runs the aritmetic operations in a non blocking manner to the client process
    - The current result of the calculation is stored as the process state, and it is mutate by client calls with operations such as `add/2` and `sub/2`

    Book section: 5.3
  """

  @doc """
  Start a new calculator server process
  - This an interface function, this means that this code runs on the client process side
  - To keep the process runing a tail recursion is needed
  - The initial state is initialized here and passes to the loop function

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> is_pid(server_pid)
      true
  """
  def start() do
    spawn(fn -> loop(0) end)
  end

  @doc """
  Get the current calculation result on the server state
  - This an interface function, this means that this code runs on the client process side
  - Interface functions abstract the implementation details to use a server process, in this example the client do not have to know that a message to get the current stat must match `{:val, pid}`
  - The `self()` call here is evaluated with the client pid, because this is an interface function

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> Chapter5.Calculator.get_result(server_pid)
      0
  """
  def get_result(calculator_pid) do
    send(calculator_pid, {:val, self()})

    receive do
      {:calc_res, value} ->
        value
    end
  end

  @doc """
  Add a value on the current state
  - This an interface function, this means that this code runs on the client process side
  - On this case the caller does not request a repsonse from the server,so no message is send

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> Chapter5.Calculator.add(server_pid, 5)
      iex> Chapter5.Calculator.get_result(server_pid)
      5
  """
  def add(calculator_pid, value) do
    send(calculator_pid, {:add, value})
  end

  @doc """
  Subtract a value on the current state
  - This an interface function, this means that this code runs on the client process side
  - On this case the caller does not request a repsonse from the server,so no message is send

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> Chapter5.Calculator.sub(server_pid, 5)
      iex> Chapter5.Calculator.get_result(server_pid)
      -5
  """
  def sub(calculator_pid, value) do
    send(calculator_pid, {:sub, value})
  end

  @doc """
  Multiply the current state by a value
  - This an interface function, this means that this code runs on the client process side
  - On this case the caller does not request a repsonse from the server,so no message is send

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> Chapter5.Calculator.add(server_pid, 5)
      iex> Chapter5.Calculator.mul(server_pid, 3)
      iex> Chapter5.Calculator.get_result(server_pid)
      15
  """
  def mul(calculator_pid, value) do
    send(calculator_pid, {:mul, value})
  end

  @doc """
  Divides the current state  by a value
  - This an interface function, this means that this code runs on the client process side
  - On this case the caller does not request a repsonse from the server,so no message is send

  Book section: 5.3.3

  ## Examples
      iex> server_pid = Chapter5.Calculator.start()
      iex> Chapter5.Calculator.add(server_pid, 5)
      iex> Chapter5.Calculator.div(server_pid, 2)
      iex> Chapter5.Calculator.get_result(server_pid)
      2.5
  """
  def div(calculator_pid, value) do
    send(calculator_pid, {:div, value})
  end

  @doc """
  This is the tail recursion used to keep the server process runing
  - This an implementation function, this means that this code runs on the server process side
  - Pattern matching is used to filter the incoming messages
  - A commom pattern is to separate all the patter matching stuff on a separate function, to avoid a huge switch like construct
  - Then a message is sent to the caller with the result of the computation done
  - Implementation functions usually are private but for documentation purpose they are pulic here
  - The new state is passed as parameter to the next loop iteration

  Book section: 5.3.1 e 5.3.2

  ## Examples
      iex> server_pid = Chapter5.DatabaseServer.start()
      iex> is_pid(server_pid)
      true
  """
  def loop(value) do
    new_value =
      receive do
        message ->
          process_message(value, message)
      end

    loop(new_value)
  end

  defp process_message(value, {:add, entry}) do
    value + entry
  end

  defp process_message(value, {:sub, entry}) do
    value - entry
  end

  defp process_message(value, {:mul, entry}) do
    value * entry
  end

  defp process_message(value, {:div, entry}) do
    value / entry
  end

  defp process_message(value, {:val, caller}) do
    send(caller, {:calc_res, value})
    value
  end

  defp process_message(value, invalid_request) do
    IO.puts("Invalid request. #{invalid_request}")
    value
  end
end
