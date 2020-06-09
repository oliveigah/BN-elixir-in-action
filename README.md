# Elixir in Action 2nd Edition - Chapter 2
This are my personal notes of the book.
## Type System
### 2.4.1 - Numbers
- Usually works as expected. 
- '/' operator always returns a Float
### 2.4.2 - Atoms
- Named constants. (eg. [:an_atom , :another_atom, :"an atom with spaces"])
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
- Tuples are untyped strucures
- Usually used to group a fixed amount of elements together
- Tuples can be manipulated by the Kernel module
- Changes on the tuple does not affect the original data just the references. (Data is always immutable)

### 2.4.4 - Lists
- Used to manage dynamic, variable-sized collections of data
- Looks like an array but in fact are singly linked lists
- Because of this, most of the operations on lists are O(n), length(list) included
- Can check if some element is on a list with the operator in (eg. 6 in list)
- Lists can be manipulated with List module functions
- Changes on the tuple does not affect the original data just the references. (Data is always immutable)
- Lists are recursively composed by head and tail structure
- Because of this insert a new element on the begining of a list is O(1) while insert on the end is always O(n)

### 2.4.5 - Data Immutability
The general idea of data immutability lead to a thought that this could be inneficient memory wise, but actually in most of the cases most of the data is shared by the old and the new version.

This is easily demonstrate with lists modification where the tail of the modificate element can be shared without any problems.

Worth to mention that some data copy is always be present, but the benefits of the immutabillity largelly surpass this downside. The two main benefits of it are:
1. Side efect free functions that are easier to analyze, predict and test
2. Data consistency that leads to the ability to perform atomic in-memory operations
