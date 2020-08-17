# **Functional Programming**
Jani Immonen, D571
jani.immonen@jamk.fi


## **Elixir**
Elixir is a dynamic, functional language designed for building scalable and maintainable applications.

Elixir is built on top of *Erlang*. Erlang was created in Ericsson in the late eighties and became opensource in the late nineties. Since then Erlang has grown in popularity to build fault-tolerant real-time applications. Erlang is untyped, has garbage collection and works with message passing between processes. Today Erlang is more than a language as it has a virtual machine and a standard library focused in *concurrency*.

Erlang powers some of the most scalable systems in the world. Probably the best example is WhatsApp, with millions and millions of messages by minute. [See how Rick Reed discusses how they acomplished this](http://www.erlang-factory.com/conference/SFBay2012/speakers/RickReed)


## **Scalability**
All Elixir code runs inside lightweight threads of execution (called processes) that are isolated and exchange information via messages:

    current_process = self()

    # Spawn an Elixir process (not an operating system one!)
    spawn_link(fn ->
        send(current_process, {:msg, "hello world"})
    end)

    # Block until the message is received
    receive do
        {:msg, contents} -> IO.puts(contents)
    end

Due to their lightweight nature, it is not uncommon to have hundreds of thousands of processes running concurrently in the same machine. Isolation allows processes to be garbage collected independently, reducing system-wide pauses, and using all machine resources as efficiently as possible (vertical scaling).

Processes are also able to communicate with other processes running on different machines in the same network. This provides the foundation for distribution, allowing developers to coordinate work across multiple nodes (horizontal scaling).

## **Fault-tolerance**
The unavoidable truth about software running in production is that things will go wrong. Even more when we take network, file systems, and other third-party resources into account.

To cope with failures, Elixir provides supervisors which describe how to restart parts of your system when things go awry, going back to a known initial state that is guaranteed to work:

    children = [
        TCP.Pool,
        {TCP.Acceptor, port: 4040}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)

The combination of scalability, fault-tolerance, and event-driven programming via message passing makes Elixir an excellent choice for Reactive Programming and Architectures.


## **Language features**

### **Functional programming**
Functional programming promotes a coding style that helps developers write code that is short, concise, and maintainable. For example, pattern matching allows developers to easily destructure data and access its contents:

    %User{name: name, age: age} = User.get("John Doe")
    name #=> "John Doe"

When mixed with guards, pattern matching allows us to elegantly match and assert specific conditions for some code to execute:

    def drive(%User{age: age}) when age >= 16 do
        # Code that drives a car
    end

    drive(User.get("John Doe"))
    #=> Fails if the user is under 16

Elixir relies heavily on those features to ensure your software is working under the expected constraints. And when it is not, don't worry, supervisors have your back!


### **Extensibility and DSLs**
Elixir has been designed to be extensible, letting developers naturally extend the language to particular domains, in order to increase their productivity.
As an example, let's write a simple test case using Elixir's test framework called ExUnit:

    defmodule MathTest do
        use ExUnit.Case, async: true

        test "can add two numbers" do
            assert 1 + 1 == 2
        end
    end

The **async: true** option allows tests to run in parallel, using as many CPU cores as possible, while the assert functionality can introspect your code, providing great reports in case of failures. Those features are built using Elixir macros, making it possible to add new constructs as if they were part of the language itself.


### **Tooling features**
Elixir ships with a great set of tools to ease development. [Mix is a build tool](https://hexdocs.pm/mix/) that allows you to easily create projects, manage tasks, run tests and more:

    $ mix new my_app
    $ cd my_app
    $ mix test
    .

    Finished in 0.04 seconds (0.04s on load, 0.00s on tests)
    1 tests, 0 failures

Mix is also able to manage dependencies and integrates with the [Hex package manager](https://hex.pm/), which performs dependency resolution, fetches remote packages, [and hosts documentation](https://hexdocs.pm/) for the whole ecosystem.

Tools like IEx [(Elixir's interactive shell)](https://hexdocs.pm/iex/) are able to leverage many aspects of the language and platform to provide auto-complete, debugging tools, code reloading, as well as nicely formatted documentation:

    $ iex
    Interactive Elixir - press Ctrl+C to exit (type h() ENTER for help)
    iex> h String.trim           # Prints the documentation for function
    iex> i "Hello, World"        # Prints information about the given data type
    iex> break! String.trim/1    # Sets a breakpoint in the String.trim/1 function
    iex> recompile               # Recompiles the current project on the fly

Elixir runs on the Erlang VM giving developers complete access to Erlang's ecosystem, used by companies like Heroku, WhatsApp, Klarna and many more to build distributed, fault-tolerant applications. An Elixir programmer can invoke any Erlang function with no runtime cost:

    iex> :crypto.hash(:md5, "Using crypto from Erlang OTP")
    <<192, 223, 75, 115, ...>>


## **Elixir, summary**
Elixir is modern and powerful programming environment which is suitable especially for solving concurrent execution in efficient manner.

