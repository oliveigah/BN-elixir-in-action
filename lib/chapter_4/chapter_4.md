# 4 - Data Abstraction

- Data abstractions are build with pure elixir modules
- These modules works as an abstraction of the data type. (eg. If you want to work with a list data type, you use the List module)
- This kind of modules have 2 types of functions
  - Modifier: Transform the input data, and return the modified version that is same type of the input. eg. `String.upcase/1` and `List.insert_at/3`
  - Query: Analyze the input data and return some piece of information about it in a different data type. eg. `String.length/1` and `List.first/1`
