# 8 - Fault Tolerance Basics

- Fault tolerance in the BEAM ecossytem is acknowledge the existence of failures, minimizing their impact and ultimately recover from them without human interaction
- Since it is impossible to predict everything that may go wrong, we assume that everything can fail, and no matter how important is a component that fail, it can not take down the entire system
- BEAM powered systems are usually self-healing systems that can recover themselves from some kind of failures
- This property is again achieved by the concurrent nature of BEAM, since two processes are completly independent agents failures are never propagated except if the developer explicitly want it

## 8.1 - Runtime Errors

- There are several ways that a runtime error can be raised, wrong aritmetics, call unknow functions and many others
- When a runtime error happens the execution control is transfered to some kind of error-handling code, if it does not exist, the process that raised the error is terminated
- Errors can be handled with `try-catch` constructs similar to other main stream languages

### 8.1.1 - Error Types

- There is 3 types of errors in BEAM
  - errors: The classical error, used when a unexpected thing happen
  - exits: A signal emited by processes that are terminating
  - throws: Stop the execution flow throwing a value to be catched later
- `raise/1` is used to raise custom errors
- There are 2 approachs of working with a function that can fail
  - Raising an error: In this case the execution will fail and an error will be raised
  - Matching the result: Informing a failure with pattern matching of the function response
- The raising error approach is usefull when the code is really unexpected to fail, if all the system functionality relies on the existance of a file that is not there, you probally wants to raise an error
- The matching result is more usefull when the code eventually can fail and it is expected
- `exit/1` is used to terminating a process and inform the reasons to do so
- `throw/1` is used to change the execution flow somewhat similat to a goto expression

### 8.1.2 - Handling Errors

- The main way to intercept errors(error, exit or throw) is by try-catch constructs
- The catch clause can use pattern matching to match errors, exactly like `case`
- The return valure of the try-catch expression is the value of the last executed statement
- The clause `after` specifies a code that will always be executed, no matter what happens
- The `after` result do not change the try-catch result value, and some syntax sugar is avaiable for it, see [the docs](https://elixir-lang.org/getting-started/try-catch-and-rescue.html)
- Tail-call optimization do not work with try catch operations as it's last expression
- In comparison to main stream languages the try-catch is way less used in elixir
- Usually elixir systems let the process crash and them handle it later, starting the process again for instance
- This works perfectly with bugs that happens randonly and are hard to reproduce, because they occur due to hardware failures and stuffs like that

## 8.2 - Concurrent System's Errors

- Although the processes are completly isolated, sometimes it's necessary to create somekind of link between them
- It may be because of a processes heavily relies on another process service or would be counter productive continuouly running the processes without the others

### 8.2.1 - Linking Processes

- Link is a concept that two processes that are linked when one of them terminated the other one will receive an exit signal containing some information about the terminated process and reasons of the crash and if the exit signal is not `:normal` the recipient process will be terminated as well
- Instead of just terminate, recipient processes can trap exits signal and handling them in some way. This can be done with `Process.flag(:trap_exit, true)`
- This makes all the exit signals to be received as mesages in the process mailbox that has a spcific pattern that could be matched on the `receive` macro
- All links are bidirectional, this means that both processes will send messages to each other in case of failures

### 8.2.2 - Monitors

- Monitors are kind of unidirectional links, one process is notified about the others failures but not the other way around
- To monitor a process use `Process.monitor(target_pid)`
- When a monitored process dies, the monitor will receive a message on it's mailbox
- There are 2 main differences between monitors and links
  - Links are bidirectional always while monitor are unidirectional
  - Links (without traps) will always terminate both processes while on monitor it's just a message, which can be handled or ignored

## 8.3 - Supervisors

- With links, exit traps and monitors, a process can detect errors in a concurrent system and act upon it based on the information that is passed to it on the error messages
- A processes that is responsible for just doing it is called a `Supervisor`
- Supervisors are generic processes that manages the lifecycle of other processes in a concurrent system
- It can start new processes, these processes there fore are called `children` of it's supervisor
- The supervisor is responsible for all its children, and receive the exit messages act upon them in a proper way
- Process that are not supervisors are called workers
- If a worker dies due to a bug, this part of the system will be gone forever
- Supervisors can be useful to restart these workers in this case
- The `Supervisor` module is used to create supervisors
- A supervisor works like this:
  1 - Traps exits
  2 - Starts all the children
  3 - At any given point in time that a child terminate, handle its exit message and perform corrective actions
  4 - If a supervisor terminates, all its children are terminated as well
- There are two main ways to start a supervisor:
  - Passing a list: Invoke `Supervisor.start_link/2` providing a list with modules to be initialized as its children together with some aditional options
  - Callback module: Implement a callback module, similar to `GenServer` approach, that return all these information about children and options
- A different start function must be used: `GenServer.start_link/3` this function must be used when you want to create a link between caller and server on the server start execution
- Options given to supervisor will dictate several aspects of the supervisor behaviour, for instance the option `:strategy` defines how children exits will be handled
- Registered processes names are important to supervisors because they provide a reliable way to finding a process and communicate to it
- Usually supervisors are wrapped inside a module

```elixir
defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [Todo.Cache],
      strategy: :one_for_one
    )
  end
end

```

- Although this simple approach of passing the children list to the `Supervisor.start_link/2` works, sometimes you need a bit more of control about what happens before and after the creation of the supervisor, for it you can build the supervisor module a bit different
- Supervisors do not try to restart children indefinetely, if a process crashes too much in predetermined period of time, the supervisor will give up and terminate it self
- The boundaries limits of this restart task can be customized inside de supervisor
- This restart frequency feature is helpful on how supervision trees works

### 8.3.1 - Child Specification

- In order to know how to work with each child the supervisor must know 3 things:

  - How should child be initialized
  - What should be dont if the child terminates
  - How to uniquely distinguish each child

- All these information is the child specification. eg:

```elixir
  %{
  id: arbitray_term_that_unique_idenfiy,
  start: {module, :start_function_name, [start_function_args]}
  }

```

- To avoid passing child specification hard coded, a default function call is implemented by `GenServer` and used by `Supervisor` this function is `child_spec/1` that return the correct child specification for the module, and can be override in case you need more control about it
