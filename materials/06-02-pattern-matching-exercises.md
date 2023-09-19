# **Functional Programming**
jani.immonen@jamk.fi

For exercises that involve checking a condition (like checking if a string starts with a certain substring), you can create functions with multiple clauses where one clause matches the condition and another clause matches any other input, returning boolean values to indicate whether the condition was met or not.

Test your solutions with different inputs to ensure they work correctly in all cases.


&nbsp;
### Exercise 1: Simple Pattern Matching with Variables

1.1. Assign the value `42` to a variable `x`.
1.2. Use pattern matching to check if `x` is equal to `42`.
1.3. Use pattern matching to check if `x` is equal to `41`.

### Exercise 2: Matching on Lists

2.1. Given a list `list = [1, 2, 3, 4]`, use pattern matching to:
   - Retrieve the first element
   - Retrieve the first two elements
   - Retrieve the last element

### Exercise 3: Matching on Tuples

3.1. Given a tuple `{:ok, value}`, use pattern matching to retrieve the `value`.

### Exercise 4: Function Pattern Matching

4.1. Create a function with multiple clauses that uses pattern matching to:
   - Return "zero" if the input is `0`
   - Return "one" if the input is `1`
   - Return "other" for any other input

### Exercise 5: The Pin Operator

5.1. Assign the value `42` to a variable `x`. Then, using the pin operator (`^`), write a pattern matching expression that matches only if a given value is equal to `42`.

### Exercise 6: Working with Atoms

6.1. Create a function with multiple clauses that uses pattern matching to return the string representation of the following atoms: `:ok`, `:error`, `:unknown`.

### Exercise 7: Pattern Matching on Strings

7.1. Given a string `"hello world"`, use pattern matching to:
   - Check if the string starts with `"hello"`
   - Check if the string ends with `"world"`

### Exercise 8: Working with List Head and Tail

8.1. Given a list, use pattern matching to:
    - Retrieve the head of the list
    - Retrieve the tail of the list
    - Check if the list is empty

&nbsp;
----
**© Jani Immonen**

