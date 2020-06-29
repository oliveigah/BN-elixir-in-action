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
