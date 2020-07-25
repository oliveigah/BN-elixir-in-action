# 7 - Building a Concurrent System

## 7.1 - Working With mix

- Mix is a built in elixir tool that helps to manage a project in tasks such as:
  - Create a new project
  - Build production code
  - Run code locally
  - Manage dependencies
  - Run tests
  - And much more
- There are loads of mix commands that are very usefull to the project development, see [the docs](https://hexdocs.pm/mix/Mix.html)
- The are no hard rules for files organization and names but a few guidelines:
  - Use a commom top level alias such as `Todo.List` or `Account.Server` to avoid naming conflicts
  - In general it is one module per file, small helper modules used inside just one module could be place inside it as well. (Protocols too)
  - File names are a snake_case version of the module's name implemented by it `Todo.List` -> `todo_list`
  - The folder structure is corerespondent to the module names as well `Todo.List` -> `lib/todo/list.ex`

## 7.2 - Managing Multiple Server Procesess

- Usually when a `GenServer` module are not named, and their numbers grow indefinitely with the system load, there is 2 options to work with this:
  - Implement a kind of collection pure functional abstraction to work with multiple data
  - Run one data process for each need
- The collection approach is not ideal because the abstraction still run under a single process, which would create a bottle neck since all clients will be addressing requests to this single process and because of the concurrent preemptive nature of BEAM the system throughput would be too low
- The multiple instance is the best choice because it fully takes advantage of the concurrent preemptive nature of BEAM, sharing the computational power between all the processes
- To implement the multiple instance solution a new entity, something to keep track of all the instances running on the system and track them by something meaningfull to the domain. A key/value structure where the value is a pid and the key something that identifies the processes in that specific domain. eg: `<cpf>: pid`

### 7.2.3 - Analyzing Process Dependencies

- Singleton processes are the first candidates of bottlenecks, because all the requests that use them can only be handled by the unique processes no paralization is possible and you will not be able to take advantage of all the CPU resources
- Beucause of this, singleton processes should not run slow operations, they must have a very high throughput otherwise it will be a huge bottleneck on the system
- Processes are internally sequential so singleton processes can be used as synchronization points on the system, because no matter how much messages are being send to it, it can only handle one at a time
- This feature is very important to the multiple instances processes too, because it guarantee that idependently of how many clients are trying to modify a specific instance, only one message will be handled at a time, totally eliminating race conditions.

## 7.3 - Addressing Bottlenecks

- Processes casts are less problematic than calls, casts from the caller pov does not affect nothing, but if the cast messages are being send faster than the server can handle the processes mailbox will grow indefinitelly impacting on future calls that will block the callers until timeout

### 7.3.1 - Bypassing process

- The bottleneck processes really need to be a process? Could it be a plain module and be executed on the caller process?
- Some flags that this processes REALLY NEED to exist:
  - The code must manage a long-living state
  - The code handle some kind of reusuable resource such as TCP connections
  - The code is a critical section of the code and must be synchronized
  - The code can not be massivelly paralized for some reason such as disk operations
- If none of this conditions are matched, this process probally do not need to be a process at all

### 7.3.2 - Handling Requests Concurrently

- [Example](https://oliveigah.github.io/banking_prototype/Account.Database.html#content)
- Usually useful when requests depends on a commom state but can be handled in paralel
- In this approach each new request to the process spawns a new process to handle it
- The problem with this is that the concurrency is unbound, that means it can grow indefinetly which may impact the system
- A typical solution for this problem is pooling
- With pooling all the requests are still handled by a single process but it just forward them to a specific worker that will do the real work
- On the singleton process creation you can define how much workers that singleton will manage

## 7.4 - Reasoning With Processes

- Processes are simple concurrent agents from the outside and fully sequential agents from the inside that can handle an internal state
- You can think about processes the same way you think about services in a microservices architecture
- The processes are mostly independent but when they need to cooperate they do it using messages that are passed with calls or casts
- Calls are suitable for the most cases, but can affect the overall responsiveness because the caller is blocked until the server response is done
- Casts can help a lot with overall responsiveness because after a call the caller is immediately free to handle another message, but the problem is the caller have any guarantee about the request sucess or fail it is a fire and forget operation
- Calls are sometimes used to apply backpressure on the callers, preventing them to spam the server with new messages which ultimately could lead to an out of memory situation where the VM would be terminated
- Call x Cast is a situational choice that should always be analyzed carefully, in a rule of thumb always start with call and move to cast if responsiveness is affected
