# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **What is Functional programming?**

From [Wikipedia](https://en.wikipedia.org/wiki/Functional_programming)

Functional programming is a programming paradigm that is based on the idea of treating computation as the evaluation of mathematical functions. It is a declarative programming style, meaning that the programmer specifies what needs to be done, rather than how it should be done.

Functional programming has its roots in lambda calculus, which is a formal system for expressing computation based on function abstraction and application. This mathematical foundation gives functional programming its theoretical underpinnings.

One of the key principles of functional programming is immutability, which means that the state of a program cannot be changed once it has been initialized. This allows for more predictable and reliable code, as well as easier parallelization and concurrency.

Another important concept in functional programming is referential transparency, which means that a function will always produce the same result given the same input. This makes it easier to reason about and test code, as well as optimize and reuse it.

Functional programming languages also often have strong support for higher-order functions, which are functions that can take other functions as arguments or return them as outputs. This allows for a more flexible and modular approach to programming.

Overall, functional programming offers many benefits for developers, such as improved reliability, ease of testing and debugging, and easier parallelization and concurrency. While it may require a different way of thinking for some programmers, the benefits of functional programming make it a powerful tool in the programmer's toolkit.

&nbsp;
### **Functional Programming Languages**

There are many programming languages that support functional programming, some of the most popular ones include:

Here are some most prominent Functional programming languages:
- [Haskell](https://www.haskell.org/): a purely functional programming language that is known for its strong static typing and clean, expressive syntax.
- [SML](https://smlfamily.github.io/): powerful and widely-used functional programming language that is known for its strong static typing and support for type inference.
- [Clojure](https://clojure.org/): powerful and flexible programming language that is well-suited for a wide range of applications.
- [Scala](https://scala-lang.org/): a hybrid functional-imperative language that runs on the Java Virtual Machine and is known for its support for functional programming and concurrency.
- [Erlang/Elixir](https://elixir-lang.org/): a dynamic, functional language that runs on the Erlang VM and is known for its simplicity and ability to handle concurrent processes.
- [Clean](https://clean.cs.ru.nl/Clean)
- [F#](https://fsharp.org/): a functional-first programming language that runs on the .NET platform and is well-suited for functional-imperative programming.
- [Mathematica](https://www.wolfram.com/language/)
- SQL


&nbsp;
### **Terminology and Concepts**
![](./img/functional-programming.png "Functional Programming Terminology and Concepts")
&nbsp;

- Immutable Data
    - Data is not modified after it has been declared.
    - Create new data structures instead of modifying ones which is already exist.
- Closure
    - The closure is an inner function which can access variables of parent function's, even after the parent function has executed.
- First-class function
    - Attributed to programming language entities that have no restriction on their use. Therefore, first-class functions can appear anywhere in the program.
- Maintainability
    - Easier to maintain as its not possible to accidentally change anything outside the given function.
- Modularity
    - Modular design increases productivity. Small modules can be implemented quickly and have a greater chance of re-use which leads to faster development time.
    - Modules can be tested separately which reduces the time spent on unit testing and debugging.
- Referential transparency
    - Functional programs should perform operations just like as if it is for the first time. Its known what may or may not have happened during the program's execution, and its side effects.
- Higher-order functions
    - Functions either take other functions as arguments or return them as results.
- Pure function
    - Function whose inputs are declared as inputs and none of them should be hidden. The outputs are also declared as outputs.
    - Pure functions act on their parameters. Output is quaranteed to be the same with the given parameters.

Example:

    function Pure(a,b)
	    return a+b

- Impure functions
    - They have hidden inputs or output. Impure functions cannot be used or tested in isolation as they have dependencies.

Example:

    int z
    function notPure(a,b)
	    z = a+b+z

&nbsp;
### **The benefits of functional programming**
* Allows you to avoid confusing problems and errors in the code
* Easier to test and execute Unit testing and debug
* Parallel processing and concurrency
* Hot code deployment and fault tolerance
* Offers better modularity with a shorter code
* Increased productivity of the developer
* Supports Nested Functions


&nbsp;
### **Limitations of Functional Programming**
* Functional programming paradigm is not easy, it can be difficult to understand for the beginner
* Hard to maintain as many objects evolve during the coding
* Needs mocking and extensive environmental setup
* Re-use is complicated and needs constantly refactoring
* Objects may not represent the problem correctly


&nbsp;
## **Summary**
When starting functional programming, we are flooded with unfamiliar terms. Immutable data, first class functions, closures, which are language features that aid functional programming. Later we may hear about mapping, reducing, pipelining, recursing, currying and the use of higher order functions as a programming techniques used to write functional code. Not to stop there, we hear about concurrency, lazy evaluation, determinism, as advantageous properties of functional programs.

Most importantly, functional code is characterised by one thing: **the absence of side effects**. It doesn't rely on data outside the current function, and it doesn't change data that exists outside the current function. Every other *functional* thing can be derived from this property. Use it as a guide rope as you learn.


&nbsp;
----
**© 2023 Jani Immonen**

