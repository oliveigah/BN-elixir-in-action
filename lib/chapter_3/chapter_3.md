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

- eg. [this module](Chapter3.Geometry.html#area/1)
- Enable the overload of a function by the specification of multiple clauses
- When you have multiple functions with the same name and arity, you have a multiclause function
- When a multiclause function is called, the runtime tries to match all of the clauses in **source code order**, the first one that succeeds executes
- All the functions are one unique function. Despite the fact that in the source code it appears to be different functions and have completely different implementations, from callers perpespective it is all one unique function.
- Even the capture operator `&` captures all the clauses
- Clauses of the same function MUST be always kept together in the source code. Even the compiler emits a warning when it is not

### 3.2.2 - Guards

- eg. [this module](Chapter3.CheckNumber.html#check/1)
- Guards extends the multiclause behaviour by enabling other conditionals on the clause in adition to the patter matching
- Not every function can be called from guards, are allowed:
  - Comparisson operators. eg.`<=`
  - Boolean operators. eg. `and`
  - Arithmetic operators. eg. `+`
  - Type check functions from Kernel module. eg. `is_number/1`
- If an error occurs during a guard validation, the clause returns false, and the runtime proceeds to the next clause
