# 6 - Generic Server Process

## 6.1 - Building It

- Much of the work and boilerplate involved in the coding of a server process can be implemented as an abstraction
- That is exactlly what `GenServer` and I built my own abstraction on [this module](Chapter6.MyServerProcess.html#content) is built for, simplify server process code with an abstraction for functionallities like spawn a new process and run the infinite loop
- The relation between the [generic server implementation](Chapter6.MyServerProcess.html#content) and the [concrete module](Chapter6.MyKeyValueStore.html#content) is something like the generic manage the flow of control (processes spawns, the infinite loop, send and receive messages, keep the process state) and the concrete module is responsible for the implementation (define the initial state, define the messages that the processes understand and handle these messages)
- Basically the [generic server implementation](Chapter6.MyServerProcess.html#content) manages all the non interface functions of a normal server process and on the other hand the [concrete module](Chapter6.MyKeyValueStore.html#content) manages all the interface functions
- Because of this, the code of a server process is much more concise and easy to understand when it takes advantage of a generic server abstraction, because it only has to deal with what is relevant to it, the implementation it self and reuse generic abstract functions to run as a server process
