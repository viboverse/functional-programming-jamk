# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Building Elixir Applications**
We will learn how to build a complete Elixir application, with its own supervision tree, configuration, tests and more.

The application works as a distributed key-value store. We are going to organize key-value pairs into buckets and distribute those buckets across multiple nodes. We will also build a simple client that allows us to connect to any of those nodes and send requests such as:

    CREATE shopping
    OK

    PUT shopping milk 1
    OK

    PUT shopping eggs 3
    OK

    GET shopping milk
    1
    OK

    DELETE shopping eggs
    OK

In order to build our first application, we are going to use three main tools:

* ***OTP*** (Open Telecom Platform) is a set of libraries that ships with Erlang. Erlang developers use OTP to build robust, fault-tolerant applications. In this lesson we will explore how many aspects from OTP integrate with Elixir, including supervision trees, event managers and more;
* ***Mix*** is a build tool that ships with Elixir that provides tasks for creating, compiling, testing your application, managing its dependencies and much more;
* ***ExUnit*** is a test-unit based framework that ships with Elixir;

In this lesson, we will create our first project using ***Mix*** and explore different features in OTP, Mix and ExUnit as we go.


&nbsp;
### **ValueStorage project**

When you install Elixir, besides getting the ***elixir***, ***elixirc*** and ***iex*** executables, you also get an executable Elixir script named ***mix***.

Let's create our first project by invoking ***mix*** new from the command line. We'll pass the project name as the argument (valuestorage, in this case), and tell Mix that our main module should be named ValueStorage, instead of the default, which would have been Valuestorage. Note that project name cannot contain uppercase letters.

    $ mix new valuestorage --module ValueStorage

Mix will create a directory named valuestorage with a few files in it:

* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/value_storage.ex
* creating test
* creating test/test_helper.exs
* creating test/value_storage_test.exs


&nbsp;
### **Project compilation**

A file named mix.exs was generated inside our new project folder *valuestorage* and its main responsibility is to configure our project. Let's take a look at it:

    defmodule ValueStorage.MixProject do
    use Mix.Project

    def project do
        [
        app: :valuestorage,
        version: "0.1.0",
        elixir: "~> 1.9",
        start_permanent: Mix.env == :prod,
        deps: deps()
        ]
    end

    # Run "mix help compile.app" to learn about applications
    def application do
        [
        extra_applications: [:logger]
        ]
    end

    # Run "mix help deps" to learn about dependencies
    defp deps do
        [
        # {:dep_from_hexpm, "~> 0.3.0"},
        # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
        ]
    end
    end

Our mix.exs defines two public functions: project, which returns project configuration like the project name and version, and application, which is used to generate an application file.

There is also a private function named deps, which is invoked from the project function, that defines our project dependencies. Defining deps as a separate function is not required, but it helps keep the project configuration tidy.

Mix also generates a file at lib/value_storage.ex with a module containing exactly one function, called hello:

    defmodule ValueStorage do
    @moduledoc """
    Documentation for ValueStorage.
    """

    @doc """
    Hello world.

    ## Examples

        iex> ValueStorage.hello()
        :world

    """
    def hello do
        :world
    end
    end

This structure is enough to compile our project:

    $ cd valuestorage
    $ mix compile

Will output:

    Compiling 1 file (.ex)
    Generated valuestorage app

The lib/value_storage.ex file was compiled, an application manifest named valuestorage.app was generated. All compilation artifacts are placed inside the **_build** directory using the options defined in the mix.exs file.

Once the project is compiled, you can start an iex session inside the project by running:

    $ iex -S mix

We are going to work on this ValueStorage project, making modifications and trying out the latest changes from an iex session. While you may start a new session whenever there are changes to the project source code, you can also recompile the project from within iex with the recompile helper, like this:

    iex> recompile()
    Compiling 1 file (.ex)
    :ok
    iex> recompile()
    :noop

If anything had to be compiled, you see some informative text, and get the **:ok** atom back, otherwise the function is silent, and returns **:noop**.

We can also recompile the project with mix clean followed by mix compile:

    $ mix clean
    $ mix compile

Note, that in order to run the application, we need to define a *start* function into a module and modify mix.exs to point at the module to start with. We will do this in future lessons.

&nbsp;
### **Running tests**

Mix also generated the appropriate structure for running our project tests. Mix projects usually follow the convention of having a <filename>_test.exs file in the test directory for each file in the lib directory. For this reason, we can already find a test/value_storage_test.exs corresponding to our lib/value_storage.ex file. It doesn't do much at this point:

    defmodule ValueStorageTest do
    use ExUnit.Case
    doctest ValueStorage

    test "greets the world" do
        assert ValueStorage.hello() == :world
    end
    end

It is important to note a couple of things:

1. the test file is an Elixir script file (.exs). This is convenient because we don't need to compile test files before running them;
2. we define a test module named ValueStorageTest, in which we use ExUnit.Case to inject the testing API;
3. we use one of the injected macros, doctest/1, to indicate that the ValueStorage module contains doctests;
4. we use the test/2 macro to define a simple test;

Mix also generated a file named test/test_helper.exs which is responsible for setting up the test framework:

    ExUnit.start()

This file will be required by Mix every time before we run our tests. We can run tests with:

    $ mix test
    Compiled lib/value_storage.ex
    Generated valuestorage app
    ..

    Finished in 0.04 seconds
    1 doctest, 1 test, 0 failures

    Randomized with seed 540224

Notice that by running mix test, Mix has compiled the source files and generated the application manifest once again. This happens because Mix supports multiple environments.

Furthermore, you can see that ExUnit prints a dot for each successful test and automatically randomizes tests too. Let's make the test fail on purpose and see what happens.

Change the assertion in test/value_storage_test.exs to the following:

    assert ValueStorage.hello() == :oops

Now run mix test again (notice this time there will be no compilation):

    1) test greets the world (ValueStorageTest)
        test/value_storage_test.exs:5
        Assertion with == failed
        code:  assert ValueStorage.hello() == :oops
        left:  :world
        right: :oops
        stacktrace:
        test/value_storage_test.exs:6: (test)

    .

    Finished in 0.05 seconds
    1 doctest, 1 test, 1 failure

For each failure, ExUnit prints a detailed report, containing the test name with the test case, the code that failed and the values for the left side and right side (rhs) of the == operator.

In the second line of the failure, right below the test name, there is the location where the test was defined. If you copy the test location in full, including the file and line number, and append it to mix test, Mix will load and run just that particular test:

    $ mix test test/value_storage_test.exs:5

This shortcut will be extremely useful as we build our project, allowing us to quickly iterate by running a single test.

Finally, the stacktrace relates to the failure itself, giving information about the test and often the place the failure was generated from within the source files.


&nbsp;
### **Automatic code formatting**

One of the files generated by mix new is the .formatter.exs. Elixir ships with a code formatter that is capable of automatically formatting our codebase according to a consistent style. The formatter is triggered with the mix format task. The generated .formatter.exs file configures which files should be formatted when mix format runs.

To give the formatter a try, change a file in the lib or test directories to include extra spaces or extra newlines, such as def hello do, and then run:

    $ mix format

Most editors provide built-in integration with the formatter, allowing a file to be formatted on save or via a chosen keybinding. If you are learning Elixir, editor integration gives you useful and quick feedback when learning the Elixir syntax.

For companies and teams, it is recommended to run mix format --check-formatted on their continuous integration servers, ensuring all current and future code follows the standard.


&nbsp;
### **Environments**

Mix provides the concept of ***environments***. They allow a developer to customize compilation and other options for specific scenarios. By default, Mix understands three environments:

* :dev - the one in which Mix tasks (like compile) run by default
* :test - used by mix test
* :prod - the one you will use to run your project in production

The environment applies only to the current project. Any dependency you add to your project will by default run in the :prod environment.

Customization per environment can be done by accessing the Mix.env function in your mix.exs file, which returns the current environment as an atom. That's what we have used in the :start_permanent options:

    def project do
    [
        ...,
        start_permanent: Mix.env == :prod,
        ...
    ]
    end

When true, the :start_permanent option starts your application in permanent mode, which means the Erlang VM will crash if your application's supervision tree shuts down. Notice we don't want this behaviour in dev and test because it is useful to keep the VM instance running in those environments for troubleshooting purposes.

Mix will default to the :dev environment, except for the test task that will default to the :test environment. The environment can be changed via the MIX_ENV environment variable:

    $ MIX_ENV=prod mix compile
    Or on Windows:

    > set "MIX_ENV=prod" && mix compile

Mix is a build tool and, as such, it is not expected to be available in production. Therefore, it is recommended to access Mix.env only in configuration files and inside mix.exs, never in your application code (lib).


&nbsp;
----
**© Elixir-Lang.org, Jani Immonen**

