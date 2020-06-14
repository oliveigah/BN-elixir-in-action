# 2 - Building Blocks

## 2.1 - Interactive Shell

- Started by the `iex` command on the console
- Starts an instance of the BEAM and a interactive Elixir shell
- You can type almost any elixir code on the shell and it'll work
- For complex multiline operations you just have to break the expression in lines in some way that it does not form a valid expression until the end.

```elixir
iex(1)> 2 * (
...(1)> 3 + 3
...(1)> ) / 4
3.0
```

- Documentation can be accessed in the shell with the command `h` it works for almost everything
- Almost everything in elixir is an expression with a return value

## 2.2 - Variables

- Dynamic language, so no explicity types. Types of variables are defined by the data within them
- Variable assigment in Elixir language is called variable binding
- snake_case is the variable names convention
- Variable names can contain '?' or '!' eg. `valid_name? = false`
- By convention variables with '?' are usually boolean values
- By convention variables with '!' are usually used to variables that can contain exceptions
- Rebinding doesnt mutate the existing memory value. It just allocate the new value on a new memory location and reassing the symbolic to the new location
- Garbage collector exists and works as expected, values in memory that can't be reached any more are eligible to the garbage collector

## 2.3 - Code Organization

- A typical Elixir program is composed by several small functions
- Organized group of functions are called Modules
- The initial project folder structure can be initiated by running the command `mix new project_name`
- Mix have it owns code formater that can be integrated with modern text editors
- Comments are done with the '#' character

### 2.3.1 - Modules

- Is a collection of functions. Kind of Java Namespaces.
- `defmodule` macro creates a module
- Elixir source files use de .ex extension
- A single .ex file can contain multiple modules, but a module must be defined in a single file
- Modules inside modules are accessible by the '.' notation and no special relation is built. Just syntax convenience
- The character '.' is avaiable to name modules but it is just a syntax convenience. No special relation are built between the modules after the compile.
- CamelCase is the module name convention

### 2.3.2 - Functions

- Every elixir function must be defined inside a module
- snake_case is the function name convention
- As variables the characters '?' and '!' are allowed too
- By convention variables with '?' are usually used when it returns a boolean values
- By convention variables with '!' are usually used to fucntions that may rise runtime errors
- `def` macro is used to create functions
- Functions with no arguments can have their parentheses ommited in the declaration
- **There is no explicit return in Elixir, instead the return value of a function is the return value of it last executed expression**
- This feature almost force the functions to be simple
- There are some condensed syntax for short functions declarations
- Parentheses in function calls can be omitted but it is not the convention
- If a function resides in the same module that it is being called the module name can be ommited

### 2.3.3 - Function Arity

- The arity of a function is the number of parameters it receives
- The unique identifier of a function is: Module + Name + Arity
- Functions with the same module and name but different arity are completely different functions, totally independent from one another
- A usual pattern in Elixir is that lower arity function delegates work to higher arity functions. (eg. Implemented on Geometry module)
- Default parameter values can be generated with the `//` operator, but remember it generates multiple separate function.
- Because of it, it is not possible to a function receive a variable number of arguments
- It's possible tho to have function overload with multiclauses functions. See [3.2.1](chapter_3.html#3-2-matching-functions)

### 2.3.4 - Function visibility

- Functions declared using the `def` macro are public and can be called anywhere in the code
- To create private functions should use `defp` macro, then it'll be accessible only inside the module

### 2.3.5 - Import and Aliasses

- You can always call a public function using the syntax ModuleName.function_name()
- If you want to ommit the ModuleName part you can `import ModuleName` on the start
- If you want to "rename" a module you can `alias ModuleName, as: MyModuleName` on the start

### 2.3.6 - Module Attributes

- Used usually as module constants eg. `@pi 3.14` or registered as metadata about the code
- Constants just exists in compile time, replacing all the references for its value
- Registered attributes such as `@moduledoc` are kept in the binary and can be accessed at runtime
- Many Elixir tools knows how to interpret such registered attributes to generate usefull stuffs like intelisense, documentation and type specifications

## 2.4 - Type System

- Elixir types can always be compared with the `>` and `<` operators, even when they are of different types
- number < atom < reference < fun < port < pid < tuple < map < list < binary

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

## 2.5 - Operators

- Logical operators works as expected. (eg. `==` | `!=` | `>=` | `||` | `&&`)
- Strict equality are avaiable just like in JavaScript (eg. `===` | `!==`)
- Short circtuit operators works as expect. (eg. `||` | `&&`)
- Unary operator `!` is avaiable and works as expected
- The pipeline operator `|>` takes the value on the left and passes it as the first argument of the function on the right.
- Pipeline operator is usefull when dealing with a serie of function transformations on data
- Most operator are actually functions (eg. `1 + 2` is the same as `Kernel.+(1,2)`)
- Although anyone should right `Kernel.+(1,2)` but this enable the usage of operator functions in anonymous function using the capture operator `&` and use them on the enumeration and stream functions

## 2.6 - Macros

- Too advanced for now. Let's learn it later. **TODO: Learn more about macros and read the book: Metaprogramming Elixir**
- One of the most important features in elixir
- Although it's importance, macros should not be over used. Actually it's considered a bad practice use macros when it is not necessary.
- From Official Elixir Docs
  > Macros should only be used as a last resort. Remember that explicit is better than implicit. Clear code is better than concise code
- Enable the creation of compile-time code transformers
- Relies on the quote unquote mechanism describe on https://elixir-lang.org/getting-started/meta/quote-and-unquote.html
- Macros parameters are not resolved as normal function parameters, they actually are quoted, and the result of the macro is a quote too
- Quote and unquote mechanism works because almost every elixir command can be decomposed as a commom standarzied list structure

## 2.7 - Elixir Runtime

- Elixir runtime is a BEAM instance
- After the compile and the system's start, Erlang takes full control
- BEAM is a VM, so like JVM it takes control of the system resources and acts as a middleman between the code and the machine

### 2.7.1 - Modules and Functions

- VM keeps track of all modules loaded in memory
- When a function is called from a module, first it checks wheter the module is loaded. If not load it. Then, execute the function
- Although you can write many modules on the same file, when it is compiled each module has it's own Elixir.name_of_the_module.beam file
- Modules are always compiled even if it is defined on IEX. Just its binary will be sotred on memory instead disk.
- Manual compiled modules `elixirc source.ex` can be used by elixir tools if they are in the same folder, some code path (defined with `iex -pa my/code/path`)
- Pure Erlang compiled modules have pretty much the same behavior
- Pure Erlang modules are Atoms, and because of this have a different naming system. `pure_erlang_module.beam` instead the elixir version `Elixir.elixir_module.beam`
- At runtime module names are atoms and somewhere on the disk is a module_name.beam file where module_name is the alias of Elixir.module_name
- Functions can be called dynamically in runtime using the kernel function apply. (eg. `apply(IO, :puts, ["Dynamic call"])`)

### 2.7.2 - How to start the runtime

- IEX:
  - Used most for casual tests and interact with a on going Elixir system
  - When the interactive shell is started, the BEAM instance is started underneath too. THe elixir shell takes the input interprets it and show to use the result of the expression that ran on BEAM.
  - Because of the "interprets" part of the IEX, its important to say that it's not a good idea makes performance tests on the IEX. The production code will always be compiled.
- Scripts
  - The `elixir` command can be used to run a single elixir file
  - All modules are compiled and stored on the memory all other code is interpreted and run on the BEAM that is stopped once is nothing more to run
  - You can prevent the BEAM to stopped after there is no more code to run with the option `elixir --no-halt script.exs`
  - This is usefull when your script just load the modules and forward the real work to concurrent tasks
- Mix tool
  - Used to manage projects that are composed by multiple source file
  - Best tool for production ready systems
  - Have several commands that helps build production ready systems. Such as `mix test` , `mix run`, `mix docs`, `mix compile`, and much more.
