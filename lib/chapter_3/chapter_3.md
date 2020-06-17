# 3 - Control Flow

- Conditionals and loops works diffenrently than expected
- If and cases are often replaced by multiclause functions
- There is no classical loop like whiles
- Athough it is possible to solve problems of any complexity with Elixir

## 3.1 - Pattern Matching

- `=` operator is NOT a assignment, it is a match
- It makes manipulate complex variables a lot easier
- It even enable you to build elegant declarative-like conditionals and loops
- The result of the match expression is always the value of right-side term
- When the term does not match to the pattern expectations on the left an error is raised
- Can be recursivelly nested
- On the left is the pattern and on the right is the term
- Variables on the pattern are bound to term values

### 3.1.1 - Match Operator

- Assigment like operations is the most basic use of the match operator `=`
- Although the expression looks like an assignment and can be treated like one, in fact it's something more complex going on
- A variable is a patter that always match with any term

### 3.1.2 - Matching Tuples

```elixir
iex(14)> {date, time} = :calendar.local_time()
{{2020, 6, 13}, {19, 27, 26}}
iex(15)> {year, month, day} = date
{2020, 6, 13}
iex(16)> {hour, minute, second} = time
{19, 27, 26}
```

- This kind of match is useful to bind individual tuple elements to separate variables
- When using this match you are saying that the term should be a tuple with 2 elements
- The variable date will be bound to the first element of the tuple and the time to the second
- Kind of JavaScript object destructuring but instead of object attributes the destructure matchers are the position on the tuple

### 3.1.3 - Matching Constants

```elixir
iex(2)> person = {:person, "Bob", 25}
{:person, "Bob", 25}
iex(3)> {:person, name, age} = person
{:person, "Bob", 25}
```

- `1 = 1` it surprisingly works
- The usage of constants on the pattern is usefull to guarantee that the term is what you expected
- This pattern is very common on Elixir, where the first element of a tuple is a Atom that defines the tuple ""type"" `{:ok, content}` | `{:error, reason}`
- When constants are used on the pattern you are making sure that the specific part of the term contains that value and you can relie on this information later

### 3.1.4 - Matching Variables

- Variables always match with the left side term and are bound to the matched value
- You can skip terms on tuples with the "_". eg. `{_, time} = :calendar.local_time()`
- The same variable can be matched multiple times. This enforce all the ocurrences has to be equal.

```elixir
iex(2)> {amount,amount,amount} = {123,123,123}
{123, 123, 123}
iex(3)> {amount,amount,amount} = {123,123,1}
** (MatchError) no match of right hand side value: {123, 123, 1}
```

- To use the variable value instead of bound it, you can use the pin operator "^".

```elixir
iex(5)> expected_name = "bob"
"bob"
iex(6)> {^expected_name, _} = {"bob", 25}
{"bob", 25}
iex(7)> {^expected_name, _} = {"alice", 25}
** (MatchError) no match of right hand side value: {"alice", 25}

```

- This is usefull when you need to build a pattern at runtime

### 3.1.5 - Matching Lists

- Works similarly to tuples
- Matching lists is usually done relying on the recursive nature eg. `[head|tail] = [1,2,3]`
- This pattern is usually useful when matching function arguments

### 3.1.6 - Matching Maps

- eg. (`%{age: age, works_at: works_at} = %{name: "Bob", age: 25}`)
- Worsk similary to JavaScript object destructuring

### 3.1.7 - Matching Binarys

- eg. `<<b1,b2,b3>> = binary`
- You can use the "::" operator to define different sizes eg. `<<a :: 4, b :: 4>> = <<155>>`
- On binary strings the match works kind of like operations

```elixir
iex(13)> command = "ping www.example.com.br"
"ping www.example.com.br"
iex(14)> "ping " <> url = command
"ping www.example.com.br"
iex(15)> url
"www.example.com.br"

```

### 3.1.8 - Compound Matches

- The fact that the result of a match expression is the right term value, enable elegant oneliners

```elixir
iex(20)> {date , {hour, _ , _}} = :calendar.local_time()
{{2020, 6, 13}, {20, 24, 35}}
iex(21)> date_time = {date , {hour, _ , _}} = :calendar.local_time()
{{2020, 6, 13}, {20, 25, 25}}
iex(22)> {date, _} = {_ , {hour, _ , _ }} = :calendar.local_time()
{{2020, 6, 13}, {20, 26, 9}}
```

## 3.2 - Matching Functions

- The pattern matching feature is used in the specification of a function arguments
- This enable a input validation at runtime on function calls
- For instance if you want a tuple containing 2 elements and receive just a tuple with 1 element the call will raise an error
- The patter matching feature on function arguments empowers one of the most important Elixir features, multiclause functions

### 3.2.1 - Multiclause functions

- eg. [this function](Chapter3.Geometry.html#area/1)
- Enable the overload of a function by the specification of multiple clauses
- When you have multiple functions with the same name and arity, you have a multiclause function
- When a multiclause function is called, the runtime tries to match all of the clauses in **source code order**, the first one that succeeds executes
- All the functions are one unique function. Despite the fact that in the source code it appears to be different functions and have completely different implementations, from callers perpespective it is all one unique function.
- Even the capture operator `&` captures all the clauses
- Clauses of the same function MUST be always kept together in the source code. Even the compiler emits a warning when it is not

### 3.2.2 - Guards

- eg. [this function](Chapter3.CheckNumber.html#check/1)
- Guards extends the multiclause behaviour by enabling other conditionals on the clause in adition to the patter matching
- Not every function can be called from guards, are allowed:
  - Comparisson operators. eg.`<=`
  - Boolean operators. eg. `and`
  - Arithmetic operators. eg. `+`
  - Type check functions from Kernel module. eg. `is_number/1`
- If an error occurs during a guard validation, the clause returns false, and the runtime proceeds to the next clause

## 3.3 - Conditionals

### 3.3.1 - Multiclause branching

- eg. [this function](Chapter3.ListHelper.html#sum/1)
- As seen, patter matching on multiclause functions can be used to build conditionals that are applied on inputs parameters

### 3.3.2 - Classical branching

- If

  ```elixir
  iex(1)> if true, do:
  ...(1)> "Success",
  ...(1)> else:
  ...(1)> "Failure"
          "Success"
  ```

  - Works as expected
  - One-liners can be done as `if condition, do: somehting_to_do, else: another_thing_to_do`
  - The return value of an if statement is the return valur of the executed block, if no block is executed the result is `nil`

- Unless

  - same as `if(!condition)`

- Cond

  - eg. [this function](Chapter3.CheckNumber.html#cond_check/1)
  - Can be explained as if else if
  - The first condition that is true has its code executed
  - If no condition is valid, raises an error

- Case

  - Similar to switch-case on mainstream languages
  - Uses patter matching instead of simple bollean expressions
  - The first pattern that is matched has its code executed
  - If no pattern is matched, raises an error
  - Can serve as a substitute to multiclause functions on simple tasks

  ### 3.3.3 - The With Special Form

  - eg. [this function](Chapter3.MapHelper.html#normalize_user!/1)
  - Useful to chain pattern matching expressions and return the result value of the first one that fails
  - If all clauses are matched the do block is executed
  - Guards can be used on patterns as well
  - All variables declared inside `with` are restricted to that scope
  - An `else` block can be used in case of failures

## 3.4 - Loops and Iterations

- Definitely doesn't work as expected
- The unique looping tool in Elixir is recursion
- Other high-order functions that are usefull to do iterations are built in on top of recursions
- Although recursion is the main loop building block, high-order functions provide abstractions to deal with it for recorrent simple tasks

### 3.4.1 - Iterating With Recursion

- eg. [this function](Chapter3.ListHelper.html#non_tail_range/2)
- Usually are built with multi-clause functions. eg. [this function](Chapter3.ListHelper.html#sum/1)
- First clause is the recursion stop condition and the other clauses the general cases
- The usual memory problem with long recursions is solved in Elixir by tail-call optimization

### 3.4.2 - Tail Function Calls

- eg. [function 1](Chapter3.ListHelper.html#tail_len/1) | [function 2](Chapter3.ListHelper.html#tail_positives/1) | [function 3](Chapter3.ListHelper.html#tail_range/2)
- A tail call happens when the last expression of a function (it's return value) is a call to another function(even it self, in case of recursive tail functions)
- A tail calls works with any branching constructs such as `if` or `cond`
- If the last expression is something like `1 + call_to_a_func()` this is not a tail
- The optimization consists in instead of make a stack push for new function calls something like a goto occurs
- This is possible because since the function final value is the value of the next function being called, no context needs to be stored for later computation
- This feature is especially good in recursive functions, since recursive calls don't allocate extra memory a recursive tail function can run, virtually, forever
- This kind of function is the appropriate solution for large iterations
- Tail recursions are kind of the substitutes for traditional loops, it have an accumulator, an iteration step on the general cases clauses and the stop condition on the first clause
- The downside is that sometimes the classical recursion is more elegant solution than the tail recursion, so it is a matter of readabillity x performance

### 3.4.3 - Higher Order Functions
- WIP