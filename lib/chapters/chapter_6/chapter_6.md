# 6 - Generic Server Process

## 6.1 - Building It

- Much of the work and boilerplate involved in the coding of a server process can be implemented as an abstraction
- That is exactlly what `GenServer` and I built my own abstraction on [this module](Chapter6.MyServerProcess.html#content) is built for, simplify server process code with an abstraction for functionallities like spawn a new process and run the infinite loop
- The relation between the [generic server implementation](Chapter6.MyServerProcess.html#content) and the [callback module](Chapter6.MyKeyValueStore.html#content) is something like the generic manage the flow of control (processes spawns, the infinite loop, send and receive messages, keep the process state) and the callback module is responsible for the implementation (define the initial state, define the messages that the processes understand and handle these messages)
- Basically the [generic server implementation](Chapter6.MyServerProcess.html#content) manages all the non interface functions of a normal server process and on the other hand the [callback module](Chapter6.MyKeyValueStore.html#content) manages all the interface functions
- Because of this, the code of a server process is much more concise and easy to understand when it takes advantage of a generic server abstraction, because it only has to deal with what is relevant to it, the implementation it self and reuse generic abstract functions to run as a server process

## 6.2 - Using GenServer

- `GenServer` is a built in feature of erlang that enable the creation of generic server process whith rich feature supports
- System that relies on `GenServer` are, by design, ready for work in a distributed envinronment
- `GenServer` relies on OTP Behaviours

### 6.2.1 - OTP Behaviours

- Behaviour is a generic code that implements a common pattern
- Kind of interfaces on OO world
- A behaviour expect a set of functions to be implemented and exported by a callback module
- Behaviours guarantee that if your callback module implements the expected set of functions, your module will be ready to be empowered by all the BEAM and Erlang benefits
- Standard Erlang OTP Behaviours:
  - gen_server: Server processes
  - supervisor: Error handling and recovery
  - application: Components and libraries
  - gen_event: Event handling
  - gen_statem: Finite state machine on server processes
- Elixir has its own wrappers for the most commom behaviours

### 6.2.2 - Plugging Into

- eg. [this module](Chapter6.KeyValueStore.html#content)
- The macro `use` is frequentlly used to get default implementations for required callback functions at compilation time `use GenServer`
- Then you can overwrite the default implementations with specific ones

### 6.2.3 - Handling Requests

- The basic callback functions to work with `GenServer` are:
  - `init/1`: Used in the server initial state definition
  - `handle_cast/2`: Handle async calls to the server
  - `handle_call/3`: Handle sync calls to the server
- The general idea behind it is pretty similar to our [self implemented](Chapter6.MyServerProcess.html#content) server process
- In order to work with it perfectly just remember to follow the docs to implement the corrects signatures and responses formats
- `GenServer.start/2` is synchrounously, so the client that initializes it will be blocked until it fully launched
- `GenServer.call/2` does not wait forever, by default it just waits 5 sec

### 6.2.4 - Handling Plain Messages

- Messages sent to the server process via `GenServer.call/2` and `GenServer.cast/2` have more data than the simple message data
- It contains a kind of message type identification, such as "call" or "cast", because of it `GenServer` can handle specific messages in different ways
- Sometimes you need to handle messages that are not specific to `GenServer`, which means it does not contains a `:call` or `:cast` attached to it
- For handle this type of messages you must use the `handle_info/2` callback function. [eg. this function](Chapter6.KeyValueStore.html#handle_info/2)
- All the messages that arrive to the server that are not call neither cast are handled by `handle_info/2`

### 6.2.5 - Other GenServer Features

- eg. [this module](Chapter6.KeyValueStore.html#content)
- The attribute @impl indicates that the following function must implement a callback function, this enable compile time checking
- Server process can be named and therefore referenced by it's name instead of it's pid, this helps both, simplify the code and patterns of fault tollerance which will be discussed latter
- Each callback function have a set of possible return patterns that will guide the execution of the server process
- The basic sucessfull responses are:
  - `{:ok, initial_state}` from `init/1`
  - `{:reply, response, new_state}` from `handle_call/3`
  - `{:noreply, new_state}` from `handle_cast/2` and `handle_info/2`
- Besides the sucessfull responses, are some others possible responses such ass `{:stop, reason}` and `{:stop, reason, new_state}`
- This kind of responses are used to gracefully terminate the server and provides information about it
- Dont forget to check the docs to a complete overview of the possible responses patterns and its uses
- It is important to keep track of where the code will be executed, on the client or in the server. Book page 176 has a nice diagram about it

### 6.2.7 - OTP Compliant Processes

- In production system you should avoid use the plain `spawn/1` function
- Instead all your processes should be OTP compliants, which means that they follow the OTP conventions so can be used in supervision trees and errors are handled with much more details
- All processes powered by `GenServer` are automatically OTP compliant
- Besides `GenServer` elixir has much more modules that are OTP Compliant and can be used in many different use cases for example the modules `Task` and `Agent`
- Some others third-parties libraries implements OTP compliants abstractions too
- Most of these abstractions are built on top of `GenServer` so properly understand of `GenServer` will help you to learn each one of these abstractions
