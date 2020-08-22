# 10 - Beyond Genserver

## 10.1 - Tasks

- Tasks are used when you need a one off job. A job that executes and terminate it self when done.
- In this sense `Task` and `GenServer` has 2 different workflows. Tasks does not serve any requests, just execute his job and it's done
- Task can be interpreted as a concurrent function call

### 10.1.1 - Awaited Tasks
```elixir
long_job = fn -> 
    Process.sleep(2000)
    :some_result
end

async_task = Task.async(long_job)

# No sleep at all is executed. All computation is done by another process
# Waits for the async_task response
result = Task.await(async_task) 
```
- Awaited tasks send the result value back to the caller when the computation is done 
- Very similar to javascript's async await pattern

### 10.1.2 - Non Awaited Tasks

```elixir
defmodule SupervisedTask do
    use Task

    def start_link(_arg) do
        Task.start_link(&do_something/1)
    end
end
```

- Non awaited taks does not return any value back to the caller, instead it just terminate with `:normal` reason
- The main use case of non awaited tasks are to start async jobs under a supervisor, and be able to restart them if anything goes wrong

## 10.2 - Agents
```elixir
defmodule AgentPoweredServer do
    def start_link(_) do
        Agent.start_link(fn -> )
end
```
- `Agent` are a simple version of `GenServer`, they require less boilerplate and are more straightforward
- `Agent` is kind of a `GenServer` that can be manipulated via lambda functions
- Agents holds a state that can only be manipulated via injected functions
- Because of it, it is a best practice always wrap an agent code inside a module
- The down side is that `Agent` does not support as many use cases as `GenServer`, agents can not handle plain messages
- As a rule of thumb, if you dont need `handle_info` or `terminate` on your `GenServer`, it probally can be replaced by an `Agent` 

## 10.3 - ETS Tables
[Example](Chapter10.EtsKeyValue.html#content))
- It is a mechanism that allows share data between multiple processes more efficiently
- Used as an optimization tool, nothing can be done with ETS that can not be done with `GenServer`
- Typical scenario to use an ETS table is shared key/value structures and counters. The usage of other mechanism to solve this problem would probally lead to scalability issues (See: [GenServer Implementation](Chapter10.KeyValueStore.html#content) vs [ETS Implementation](Chapter10.EtsKeyValue.html#content))
- The main difference is that on the GenServer implementation, requests to the data structure are limited by the process execution time, while on the ETS version, all the requests have access directly to the data itself.
- ETS features:
    - Mutable
    - Writes and Reads are concurrent
    - Last write wins
    - Any data, in or out, is deep copied
    - No pressure on garbage collector, deleted data, is automatic released
    - Linked to its owner process
    - Other than owner process termination, there is no way to release ETS memory
    - Read data with patterns
