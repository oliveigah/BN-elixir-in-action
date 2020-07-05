# 5 - Concurrency Primitives

- Elixir is all about building bighly avaiable systems, which means a system that have 3 important features:
  - Fault-tolerance: Minimize, isolate and recover from unexpected errors
  - Scalability: Cappable of handle more trafic by horizontally scalling without redeploys
  - Distribution: The system runs on multiple machines, so one machine crash does not impact the whole system
- Concurrency vs Parallelism
  - Concurrency means independent execution contexts, but not necessarlly Parallelism
  - Parallelism means that two tasks are executed at the same time
  - Parallelism can not be done in a single CPU core machine
  - All parallelism is congruent but not all concurrency is parallel

## 5.1 - Concurrency In BEAM

- The basic building block of concurrency on BEAM is a process
- A BEAM process is different from a OS process, BEAM process is much lighter and cheaper to built and maintain
- All the processes are handle by BEAM schedulers
- By default, BEAM allocates 1 scheduler for each CPU core on the machine it is running
- Each scheduler has it's own thread of execution
- The entire BEAM lives in a single OS process
- Schedulers distributed the computational power equally among all the process handle by it, in an interchangeable and preemptive manner
- Process are REALLY light, the virtual limit imposed by the VM is 134.000.000 processes
- Process do not share any memory with each other, even if they are under the same scheduler
- Process communicate by to each other sending messages

## 5.2 - Working With Process

- eg. [this module](Chapter5.QueryHelper.html#content)
- Useful to paralelize work such as database queries or computation when the server machine has multiple cores
- Useful to separate execution contexts to achieve concurrency

### 5.2.1 - Creating a Process

- New process can be created by the kernel's function `spawn/1`
- `spawn/1` receives a function to be executed by the new process and returns it's pid
- A useful technique to pass data between process is by using the closure mechanism on it's creation. eg. [this function](Chapter5.QueryHelper.html#execute_query_on_another_process/1)
- All the data passed to the process is deep copied
- Because of concurrency, order among multiple processes is not a guarantee

### 5.2.2 - Message Passing

- The only way two process can exchange data is through messages
- The content of a message can be litreally anything that a variable can hold
- Messages are send with the `send/1` kernel's function
- All the message data is deep copied to the receiver's inbox
- The process inbox is a FIFO queue limited only by the memory
- Messages are consumed from the inbox in the order received, and can only be removed once it is consumed
- When a new process is spawned it must know the caller pid if the caller need the result value of it computation, to accomplish this the caller must embed his pid, wich can be obtained using `self/0`, into the new process. eg. [this function](Chapter5.QueryHelper.html#execute_query_on_another_process/1)
- Messages are received by using the `receive` macro, wich works similar as `case`. eg. [this function](Chapter5.QueryHelper.html#get_some_result_from_inbox/0)
- `receive` takes multiple patterns and tries to match every message on the queue, from oldest to newest, the first one that matches has his code block executed
- If any message matches, the process waits until the next message arrive, and checks it.
- To set a kind of timeout use the `after` macro, this way the process will not wait forever
- Receive messages takes no action from the receiver, so no block or interrupt happens
- Because of concurrency, order among messages is not a guarantee

## 5.3 - Stateful Server Process

- Beyond do async work, process can manage CPU bound operations too and being used to manipulate data
- Server process works kind of OO objects. They have a state that could be manipulated overtime
- Since processes are concurrent, multiple objects can run at the "same time"

### 5.3.1 - Server Process

- It is a process that run indefinitely and can handle messages, kind of an end-point
- Server processes are kept alive indefinitely by a [tail loop recursion](chapter_3.html#3-4-loops-and-iterations). eg. [this function](Chapter5.DatabaseServer.html#start/0)
- The loop, waits for a message to handle, when received handle it and goes back to wait the next message
- Wait for a message do not consume any CPU
- Server processes have 2 type of functions
  - Interface functions: Functions that are public and are called by the clients, the code inside these functions is executed on the client so functions like `self/0` are evaluated with the client pid. These functions are usefull to abstract implementation details and communication protocols away from the client. eg. [this function](Chapter5.Calculator.html#get_result/1)
  - Implementation functions: Functions that are private and always run on the server, these functions are responsible for the implementation details it self. eg. [this function](Chapter5.Calculator.html#loop/1)
- There is no relation between modules and processes, functions from the same module can run in different process, such as the interface x implementation example above
- `GenServer` can be used to simplify the development of server processes
- Server processes are internally sequential, this means that all the messages send to it will be handle in order, one at a time
- Because of this feature, a server process can be considered as a sync point. Use it when multiple actions needs to happen in a sync manner
- This sync feature can be bad sometimes(eg. database server), so to get around it you just have to start multiple servers, kind of a pool, and paralelize everything that you could

### 5.3.2 - Immutable State

- [this module](Chapter5.DatabaseServer.html#content)
- The state is passed through the loop function parameters

### 5.3.3 - Mutable State

- [this module](Chapter5.Calculator.html#content)
- The state is passed through the loop function parameters and changed by the message handler functions
- This aproach can feels like an mutable data structure, but it is not
- Pure functional abstractions are used inside the server process to handle all the requests
- In this way, the server process is just a controller of a pure functional abstraction that can be manipulated by other processes

### 5.3.4 - Complex State

- Same as mutable state, but the handle functions pass more complex data to the loop

### 5.3.5 - Registered Processes

- Server process can have a local inside a BEAM instance
- This name enable a simplification of the server process interface by removing the server pid repetition on the interface functions
- This is done by `Process.register/2`
