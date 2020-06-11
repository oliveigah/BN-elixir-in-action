# 1 - Erlang and Elixr

## 1.1 - Erlang

Erlang is more than a programming language, it is a development platform. It is designed by Ericsson in 1980s to solves the telecom system problems at the time, where properties like reliability, responsiveness, scalability and constant avaiability were imperative.

Despite this fact, Erlang does not provide any special abstractions for telecom system, it is actually a general purpose platform that solves hard technical problems such as concurrency, scalability, fault-tolerance, distribution and high avaiability in a very unique way.

Back to 90s these kind of problems just exists on the telecoms world, but today, these are the same problems that almost every large system have to deal with. And solve these kind of problems is the purpose of Erlang. Erlang has been used for decades now, it empowers various types of systems since Whatsapp to RabbitMQ, passing through multiplayer backends and Heroku Cloud System. Its a proven technology that empowers great software since late 80s.

### 1.1.1 - High Avaiability

Erlang platform is well known by provide to the systems empowered by it the following features:

- Fault-tolerance: Unexpect errors happens, that is a fact. But the impact of it can be minimized. A fault tolerant system is a system where an unforeseen failure affects the minimal amount of the system's services. (eg. If Netflix has a problem with the recomendantion service we dont want the streaming service be affected by it, by any means) (eg. If a user send an input that broke the feature, idealy the other users that sent valid inputs should not be affected)

- Scalability: A scalable system is a system that is able handle any possible load, quicklly and ideally with no down time. It is usually do by scalling horizontally, since the vertical scale has a well defined limit where it caps.

- Distribution: Since the best way to scale is horizontally, its natural to this kind of system be distributed. That means that a task could be handle by many different machines, this machines are totally separate devices that works together to complete the task. But being a distributed system causes a load of challenges to solve, and thats why Erlang is so helpfull

- Responsiveness: A responsiveness system should keep it response time low even whith load increases, unexpected errors or occasional lengthy tasks.

### 1.1.2 Erlang Concurrency

Erlang solves these problems using it's virtual machine called BEAM. Diferent of manny modern languages that relly on threads and OS process, Erlang takes the concurrency into its own hands.

The BEAM takes control of the OS and uses its own schedulers to distribute the work for each process. **Erlang process are different than OS process, Erlang process are orders of magnitude lighter than OS process, an Erlang sytem can run millions of these processes**.

With BEAM and process, Erlang is able to solve:

- Fault-tolerance: Since the process dont share any kind of memory with each other, an error on a process cant affect the other. Moreover, Erlang provides tools to detect and handle process crashes. Usually starting a new process on its place.

- Scalability: The no memory share rule of the Erlang process makes typical sync mechanism like, locks, mutexes or semaphores unnecessary. This makes all the interactions between this concurrent process much simpler.

- Distribution: There is no difference in the communication between two process on the same BEAM instance and two process in different BEAM instances. This way the communication between process in a single machine or distributed along many machines is the same.

- Responsiveness: BEAM process management is preemptive. It means that each process run for a brief period then it is paused. Since the execution time is small a single demanding task cant block the rest of the system. I/O operations are internally delegated to threads. Even the garbage collector is executed just inside the process when needed.

### 1.1.3 - Server-side Systems

- Erlang is usually used to build serve-side systems
- A complex project can be built relying just on Erlang
- Despite this, the Erlang built tools may not be enough for the purpose, then you should move for a mainstream tool for the job

## 1.2 - Elixir

- Elixir enables to write more cleaner and compact code that runs on the BEAM
- After compile, there is no efficiency gap between the Elixir and Erlang code
- Pure Erlang modules can be run on Elixir
- There is not you can do in Erlang that cant be done in Elixir
- In summary, Elixir is Erlang with more modern syntax and development tolling

## 1.3 - Disavantages

- The nature of frequent context switches makes Erlang a not very fast language. It's because the goal is to be reliable, keeps performance predictable and between limits. An Erlang system average response time should not vary much for diffent user load.
- Not prime tecnology for heavy CPU bound operations
- The ecosystem around Elixir and Erlang are yet relatively small
