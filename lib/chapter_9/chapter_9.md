# 9 - Isolating Error Effects

## 9.1 - Supervision Trees

### 9.1.1 - Loosely Dependent Parts

- Starting workers processes within other workers can lead to a coarse-grained error recovery, because exit signals will be send to all linked processes
- The usual approach is to have all independent or loosely dependent processes directly linked to supervisors
- All childs initialization is synchronously, and in order as specified. If a child process need more complex initialization, use the self message trick

### 9.1.2 - Rich Process Discovery

- Since processes can be restarted by supervisors, the system can not relie on processes pids. Because a certain process can be restarted and has a different pid now
- To solve this problem we need a mechanism that allow processes to be registered with a symbolic name, which could be an arbitrary term instead of just atoms that registered names
- Such mechanism would make possible every time a process is restarted, it be registered under the same name, and all reference to it would be via this symbolic name instead of pid
- This mechanism in elixir is the `Registry` module, which works as an key/value pair between arbitrary terms and pids
- Internally `Registry` is powered by ETS which make it much more powerfull than a simple map
- A process can register it self to a `Registry` using the function `Registry.register/3`
- Registered processes can be discovered using the function `Registry.lookup/2`
- One usefull property of registries is that it links to all registered processes, so it can automatically remove a process from the register when the process terminate

### 9.1.3 - Via Tuples

- [Example](Chapter9.EchoServer.html#content)
- Until now, the only way you have to identify processes was pid, which is the raw process address on BEAM
- An alternative to pids are via tuples, they identifie a process not with raw pid, but providing a way of discover it
- A via tuple format is something like this `{:via, some_module, some_arg}`, and it provides information about how to discover the process pid, because at the end of the day, the pid is what you want
- `:via` atom just informs that the via tuple method is being used
- `some_module` holds the module by how the discover will happen, this module that has all the behaviour "knowledge", which is a set of well defined functions
- `some_arg` holds the data that will be passed to some_module's well defined functions that enable it to find the pid
- Using via tuples processes can be registered under arbitrary complex terms as keys

### 9.1.4 - Regisitry Process

```elixir
defmodule Account.ProcessRegistry do
  def start_link() do
    Registry.start_link(name: __MODULE__, keys: :unique)
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end

```

- Registries are processes as well, so they must be supervisioned, that is why you need the `clid_spec(_)` function
- The `via_tuple/1` function will be used by any process that wants to register it self under this registry
- An usual approach to define processes keys under a registry is using a tuple like this `{module_name, id}`, this reduce the chance of a name conflict between 2 processes
- The `via_tuple/1` function is also used when a process need to discover the pid

### 9.1.5 - Supervising Supervisors

- Due to [restart frequency](chapter_8.html#8-3-supervisors), its not ideal to a supervisor handle too many children
- Therefore is a usual approach to split children between other supervisors that will be supervised by another supervisor
- Supervisors treats other supervisors different than workers, it means that they have different specifications
- This concept of supervised supervisors is what origins the supervision tree

### 9.1.6 - Organizing Supervision Tree

- Although supervision tree play an important role on fault-tolerance topic, it most important role is to provide a proper start order for the system
- If processes are kind of services, supervisors are service managers, kind of a built in systemd
- By holding the knowlodge of how system should be started, supervisors provide a way to stop/restart specific parts of the system without have to worry about side effects, because all children will be taken down and restarted correctly
- This allows to reasoning about errors on the system much easier
- All processes that are started under a supervisor must be OTP compliant
- Plain `spawn_link` processes should not be handled by supervisors directly, although it can be used on workers
- Another important feature is the ability to shutdown the system (or parts of it) without leave dangling processes behind
- Workers that traps exits have a chance to perform some action before being terminated by the supervisor in a system terminate scenario
- Supervisors can be informed of how treat workers termination individually, if it waits, for how long, etc
- Workers can inform the supervisor how to treat their faliures:
  - Restart the process is the default one
  - :temporary workers are not restarted when terminated
  - :transient workers are restarted only if it terminates abnormally
- Supervisors can have different restart strategies
  - :one_for_one restart only the crashed process
  - :one_for_all restart all children
  - :rest_for_one restart only younger siblings of the crashed worker, as specified on initialization

## 9.2 - Dynamic Supervisors

- In some cases, the default implementation of providing before hand all the children to supervisor are not what you need
- When children can come and go by demand a `DynamicSupervisor` is needed
- Children can be added dynamically using the `DynamicSupervisor.start_child/2` function
- All initialization is synchronously

## 9.3 - Let It Crash

- The supervision tree concept allows a very elegant and eficient way to handle unexpected errors
- Because of it the code is way clearer, without any defensive constructs noise
- This style of programming is described by Joe Armstrong in his [PhD thesis](http://erlang.org/download/armstrong_thesis_2003.pdf)
- When a process crash it is restarted with a clean state, some requests will fail, but the entire system functionality will be back to normal soon, because all the things are starting fresh
- Although "Let it crash" is different from "Let everything crash", some processes and errors must be handled explicitly
  - Critical processes
  - Erros that can be meaningful handled

### 9.3.1 - Critial Processes

- Critical processes, informally called error-kernel processes are:
  - Processes the entire system relies on
  - Processes which the state can not be restored in a simple and consistent way
- This kind of code must be as simple as possible, a usual pattern to simplify error-kernel processes is to split it into two processes, one handle the logic and other handle the state, this way the logic one can be easily restarted because it has no state and the state one is hard to crash because it just handle state
- Try catch mechanism can be used in every message handler function, and if something goes wrong, just keep the previous state

### 9.3.2 - Meaningful Errors

- The point of supervisors is to handle unexpected errors
- In general, if you know what to do with an error you must handle it
- For instance, an access denied error on an archive must be treated asking for the users password

### 9.3.3 - Preserving State

- By default, state is not preserved on process crash, so you have to implement it if you need it
- The usual approach is to have the state being saved outside the process, a database or another process for instance, and restore this state when the process restart, the previous state is restored
- Be careful when preserving state, if a corrupted state is preserved, the process will be crash rapidly everytime it is restarted, ultimately taking down his supervisor
- As a rule, the state should be persisted just after all transformation is done, and consistency is guarantee
- Ideally, restart clean always it is possible
