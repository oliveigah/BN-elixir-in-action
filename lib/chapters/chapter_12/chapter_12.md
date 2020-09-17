# 12 - Distributed System

- To build a really realiabe and scalabe system, you must distribute it among many machines to avoid single point of failure and be able to scale horizontally by adding more machines to the cluster with minimal downtime
- The BEAM powers distribution the same way it powers concurrent computation, with processes and messages
- A typical BEAM concurrent system has a lot in commom with a distributed system, because processes act like remote components
- Although BEAM provides great building blocks to work with distributed system, there is no magic. You still have to deal with non trivial challenges that all distributed systems have, but thanks to the great support of the BEAM platform, you can focus on the core challenges instead of other problems that are commom in other platforms.

## 12.1 - Distribution Primitives

### 12.1.1 - Node Communication

- The distribution on BEAM is built by connecting multiple named BEAM instances that are called nodes
- The communication between processes on different nodes is done by the same pid mechanism
- Nodes are connected via TCP connections using the function `Node.connect/1`
- By default all nodes on the cluster are full connected, which means A -> B and B -> C, results in A -> C as well
- The `Node` module contains many usefull functions to manage node and clusters informations
- After the connection, the node keep track of the other nodes on the cluster by periodically tick messages
- Node disconnections can be monitored using `:net_kernel.monitor_nodes`
- Nodes can communicate with each other using messages, the same messages used in processes communication
- A process on Node A can send a mesasge to another process on Node B, just using it's pid
- Arbitrary node's functions can be call via MFA from any other node
- Local registration is guarantee to be unique only inside the same node
- `GenServer` module has some usefull features to call functions over multipĺe nodes like `GenServer.multi_call/4` and `GenServer.abcast/3`
- Processes links and monitors works across nodes as well
- There is a lot of others modules very useful to work on a distrubuted enviornment such as: `:rpc`,`Node`, `:net_kernel`, `:net_adm`

### 12.1.2 - Process Discovery

- Process discovery is a very important operation on BEAM systems, a typical pattern of process communication is:
  1 - Client process obtain the server's pid
  2 - Client interact with the server using the obtained pid via messages
- The `Registry` module is not cluster aware, so it is usefull only to discovery local processes
- The simplest but not most efficient way to register a process on all nodes is by using global registration with the `:global` module
- `:global` module uses cluster-wide locks, use it wisely, sync with processes instead of locks whenever it is doable
- Global registration guarantee that only one process with the defined name is alive among all nodes
- Global registration works like a distributed version of `Registry`, using an ETS to store the current processes on the cluster.
- The ETS table is replicated on all nodes, because of this writes are chatty and expensive but reads are fast
- Remote processes have the first number of the pid > 0
- Crashes on globally registered processes are handled by the nodes, that will unregister them from the local ETS
- You can register multiple process under a same arbitrary alias, grouping them to reach a message broadcast group
- The usual way to group processes is using `:pg2` module, using it an alias correspond to a list of pids, which is also implemented as a distributed version of `Registry` using ETS tables

## 12.2 - Building a Cluster

- The main challenges resides on process registration and discovey, how to distribute processes among all nodes equally
- Global registration and hash functions can be used to achieve this goal, but the problem is what to do on net splits
- Handle nodes disconections, change the distribution rules, live data migration between nodes, all this problems come to place when dealing with net splits
- Redundancy can also be achieved with cluster, calling the same function on all nodes will result on redundancy
- Net splits are inevitable, and can occur by many reasons, the problem is as a external node you can never know exactly why the other node is not responding, it all looks the same from outside
- In split brains scenarios you may end with inconsistant data, wich have to be handled deliberatly
- There is several techniques and articles on the subject
- BEAM provide a way to detect nodes disconections, so you can hande them in a proper way

## 12.3 - Network Considerations

- Nodes have names, short/long name. Both are made of 2 parts, first an arbitrary term and second a resolvable address
- Names are used to make connections between nodes
- It is possible to use symbolic names such as: `iex --name node1@some_host.some_domain`
- Nodes must have the same name type(short/long) to connect with each other
- The only security tool built in clusters is the connection cookie, an atom used as a password to enter on the cluster, all nodes on the cluster must have the same cookie
- Cookies are automatically generated on BEAM initialization, and can be visualized with `Node.get_cookie` and set with `Node.set_cookie/1`
- You can have hidden nodes to serve different purposes
- BEAM base connection is done by a TCP connection on port 4369
- Other connections are random, but a range can be set as erlang flags
- Erlang distribution model is designed to run in a trusted environment, in productions BEAM instances should run under minimal privileges
