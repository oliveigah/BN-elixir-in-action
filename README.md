# Elixir in Action 2nd Edition

This are my personal notes of the book.

## Type System

### 2.4.5 - Data Immutability

The general idea of data immutability leads to a thought that this could be inneficient memory wise, but actually in most of the cases most of the data is shared by the old and the new version.

This is easily demonstrate with lists modification, where the tail of the modificated element can be shared without any problems.

Worth to mention that some data copy is always be present, but the benefits of the immutabillity largelly surpass this downside. The two main benefits of it are:

1. Side efect free functions that are easier to analyze, predict and test
2. Data consistency that leads to the ability to perform atomic in-memory operations

### 2.4.1 - Numbers

- Usually works as expected.
- '/' operator always returns a Float

### 2.4.2 - Atoms

- Named constants. (eg. `[:an_atom , :another_atom, :"an atom with spaces"]`)
- Compose of two parts text and value
- Efficient memory and performance wise because it is a link to the value and no the value it self
- Enables repeat constants without overload memory neither the code readability
- Aliases are syntax sugar for Atoms
- Booleans are Atoms

### 2.4.2 - Nil and truthy

- Nil is an Atom
- Nil and false are falsy and all the rest truthy
- Short circuits are avaiable

### 2.4.3 - Tuples

- Eg. `person = {"bob", 25}` | `age = elem(person,1)` | `put_elem(person, 1, 26)`
- Tuples are untyped structures
- Usually used to group a fixed amount of elements together
- Tuples can be manipulated by the Kernel module
- Changes on the tuple does not affect the original data just the references. (Data is always immutable)

### 2.4.4 - Lists

- Eg. `prime_number = [2,3,4,7]`
- Used to manage dynamic, variable-sized collections of data
- Looks like an array but in fact are singly linked lists
- Because of this, most of the operations on lists are O(n), length(list) included
- Can check if some element is on a list with the operator in (eg. `6 in list`)
- Can concatenate two lists with the `++` operator (eg. `[1,2,3] ++ [4,5,6]`)
- Lists can be manipulated with List module functions
- Changes on the tuple does not affect the original data just the references. (Data is always immutable)
- Lists are recursively composed by head and tail structure
- Because of this, insert a new element on the begining of a list is O(1) while insert on the end is always O(n)

### 2.4.6 - Maps

- eg. `empty_map = %{}` | `squares = %{1 => 1, 2 => 4, 3 => 9}` | `squares = Map.new([{1,1},{2,4},{3,9}])`
- It is a key/value store
- Used to manage dynamically sized key/value structures
- Used to manage simple records with a couple well-defined named fields
- Dynamically sized maps are managed by the Map module of the kernel (eg. `Map.fetch(squares,2)` | `Map.get(squares, 2)`)
- Structured data are usually managed by a notation similar to normal OO objects. (except for updates!)
- For structured data is a common pattern provide all fields of the object as Atoms on the initialization and therefore just use the update syntax
- When keys are Atoms some syntax sugar is avaiable. eg. `bob = %{name: "bob", age: 25}`|`bob.name`

### 2.4.7 - Binaries and bitstrings

- eg. `<< 1,2,3 >>`
- Are chunks of bytes
- Don't need to be a multipler of 16. But the representantion will still be in a 8bit normalized form
- When it is not a multiple of 8 it is called a bitstring

### 2.4.8 - Strings

- Elixir does NOT have a dedicated String type. Instead it is represented either as a binary or a list type
- Interpolation syntax is #{`CODE HERE`}
- Binary strings uses "
- Binary strings can be concatenated same way as binaries with the `<>` operator
- Usually binary strings are managed by the String module of the kernel
- Char lists uses '
- Char lists are a list of integers `[65,66,67] == 'ABC'` results `true`
- Most operations of the String module will NOT work with char list
- Some operations only works with char list, usually the pure erlang ones
- In general its better to endorse the use of binary strings over char lists, except when some third-party library requires the use of char lists
- It's possible to convert one type into another one

### 2.4.9 - Functions

- Anonymous functions are allowed, but the convention to write is different from the named functions. Their parameters dont have parentheses. **TODO: Why is this important? It'll be explain on chapter 3. Complement this topic when learn it**
- For code clarity purpose when an anonymous function is called it need to be called with a `.` (eg. `anonymous_func.(param1, param2)`)
- The fact that functions can be stored in variables allow to them be passed as arguments to parameterize generic logic. Similar to Javascript callback functions on methods like Array.forEach
- The capture operator `&` is used to simplify the code, diminishing the noisy, because with it there is no need to create a trivial function that just foward values to another function without any real logic
- The capture operator can also be used to shorten lambda definitions for simple functions. `lambda = &(&1 * &2 + &3)`
- Anonymous functions have access to all variables from the outside scope. Once the function is created, the function points to the outside variable values on the moment of the creation (it does not change even if these variables change are reassigned later), and hold its value until the variable that contains the anonymous function is reassigned wich makes the outside variables value used inside the function NOT eligible for garbage collection

```elixir
iex(1)> mut = 2
2
iex(2)> lambda = fn -> IO.puts(mut) end
#Function<45.97283095/0 in :erl_eval.expr/5>
iex(3)> lambda.()
2
:ok
iex(4)> mut = 4
4
iex(5)> mut
4
iex(6)> lambda.()
2
:ok
iex(7)> lambda = fn -> IO.puts(mut) end
#Function<45.97283095/0 in :erl_eval.expr/5>
iex(8)> lambda.()
4
```

### 2.4.10 - Other built-in types

- Reference: Unique values genereated inside a BEAM instance
- Pid (process identifier): Used to idenfiy erlang process ans cooperate between concurrent tasks
- Port Identifier: All the communication with the outside world is doing through it

### 2.4.11 - High level types

- Range: An enumerable for simple integer ranges, similar to python's range. (eg. `range = 1 .. 33`)
- Keyword lists: A special case of list, when all its elements are a two-element tuple and the first element of the tuple is an Atom and have a usage similar to Maps but can have multiple values for the same key and the order could be defined by the user. Mostly used in functions with optional parameters. (eg. `[{:monday, 1}, {:tuesday. 2}]`)
- MapSet: The goto structure when dealing with sets. Managed by the MapSet module.
- Date and Time: Composed by 4 modules (Date, Time, DateTime, NaiveDateTime) and can be created by sigils (~D for date, ~T form time, ~N for naive date time)

### 2.4.12 - IO Lists

- Special kind of lists.
- Usually used to incrementally build stream of bytes and forwarded it to an I/O device
- Each element is either an integer between 0 and 255, a binary or an IO List
- This list is usually build as a recursive structs like this:

```elixir
iolist = []
iolist = [iolist, "This"]
iolist = [iolist, " is"]
iolist = [iolist, " Sparta!"]
```

- This recursive build method makes all the insertion operations on the list O(1)
