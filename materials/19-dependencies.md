# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Dependencies and umbrella projects**

In this lesson, we will discuss how to manage dependencies in Mix.

Our ValueStorage application is complete, so it's time to implement the server that will handle the requests we defined in the first lesson:

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

However, instead of adding more code to the ValueStorage application, we are going to build the TCP server as another application that is a client of the ValueStorage application. Since the whole runtime and Elixir ecosystem are geared towards applications, it makes sense to break our projects into smaller applications that work together rather than building a big, monolithic app.

Before creating our new application, we must discuss how Mix handles dependencies. In practice, there are two kinds of dependencies we usually work with: internal and external dependencies. Mix supports mechanisms to work with both of them.


&nbsp;
### **External dependencies**

External dependencies are the ones not tied to your business domain. For example, if you need an HTTP API for your distributed ValueStorage application, you can use the Plug project as an external dependency.

Installing external dependencies is simple. Most commonly, we use the Hex Package Manager, by listing the dependency inside the deps function in our mix.exs file:

    def deps do
        [{:plug, "~> 1.0"}]
    end

This dependency refers to the latest version of Plug in the 1.x.x version series that has been pushed to Hex. This is indicated by the ~> preceding the version number. For more information on specifying version requirements, see the documentation for the Version module.

Typically, stable releases are pushed to Hex. If you want to depend on an external dependency still in development, Mix is able to manage Git dependencies too:

    def deps do
        [{:plug, git: "git://github.com/elixir-lang/plug.git"}]
    end

You will notice that when you add a dependency to your project, Mix generates a mix.lock file that guarantees repeatable builds. The lock file must be checked in to your version control system, to guarantee that everyone who uses the project will use the same dependency versions as you.

Mix provides many tasks for working with dependencies, which can be seen in mix help:

    $ mix help
    mix deps              # Lists dependencies and their status
    mix deps.clean        # Deletes the given dependencies' files
    mix deps.compile      # Compiles dependencies
    mix deps.get          # Gets all out of date dependencies
    mix deps.tree         # Prints the dependency tree
    mix deps.unlock       # Unlocks the given dependencies
    mix deps.update       # Updates the given dependencies

The most common tasks are mix deps.get and mix deps.update. Once fetched, dependencies are automatically compiled for you. You can read more about deps by typing mix help deps, and in the [documentation for the Mix.Tasks.Deps module.](https://hexdocs.pm/mix/Mix.Tasks.Deps.html)


&nbsp;
### **Internal dependencies**

Internal dependencies are the ones that are specific to your project. They usually don't make sense outside the scope of your project/company/organization. Most of the time, you want to keep them private, whether due to technical, economic or business reasons.

If you have an internal dependency, Mix supports two methods to work with them: Git repositories or umbrella projects.

For example, if you push the ValueStorage project to a Git repository, you'll need to list it in your deps code in order to use it:

    def deps do
        [{:valuestorage, git: "https://github.com/YOUR_ACCOUNT/valuestorage.git"}]
    end

If the repository is private though, you may need to specify the private URL git@github.com:YOUR_ACCOUNT/valuestorage.git. In any case, Mix will be able to fetch it for you as long as you have the proper credentials.

Using Git repositories for internal dependencies is somewhat discouraged in Elixir. Remember that the runtime and the Elixir ecosystem already provide the concept of applications. As such, we expect you to frequently break your code into applications that can be organized logically, even within a single project.

However, if you push every application as a separate project to a Git repository, your projects may become very hard to maintain as you will spend a lot of time managing those Git repositories rather than writing your code.

For this reason, Mix supports *umbrella projects*. Umbrella projects are used to build applications that run together in a single repository. That is exactly the style we are going to explore in the next sections.

Let's create a new Mix project. We are going to creatively name it valuestorage_umbrella, and this new project will have both the existing ValueStorage application and the new valuestorage_server application inside. The directory structure will look like this:

    + valuestorage_umbrella
    + apps
        + valuestorage
        + valuestorage_server

The interesting thing about this approach is that Mix has many conveniences for working with such projects, such as the ability to compile and test all applications inside apps with a single command. However, even though they are all listed together inside apps, they are still decoupled from each other, so you can build, test and deploy each application in isolation if you want to.


&nbsp;
### **Umbrella projects**

Let's start a new project using mix new. This new project will be named valuestorage_umbrella and we need to pass the --umbrella option when creating it. **Do not create this new project inside the existing ValueStorage project.**

    $ mix new valuestorage_umbrella --umbrella
    * creating README.md
    * creating .formatter.exs
    * creating .gitignore
    * creating mix.exs
    * creating apps
    * creating config
    * creating config/config.exs

From the printed information, we can see far fewer files are generated. The generated mix.exs file is different too. Let's take a look (comments have been removed):

    defmodule ValueStorageUmbrella.MixProject do
        use Mix.Project

        def project do
            [
                apps_path: "apps",
                start_permanent: Mix.env() == :prod,
                deps: deps()
            ]
        end

        defp deps do
            []
        end
    end

What makes this project different from the previous one is the apps_path: "apps" entry in the project definition. This means this project will act as an umbrella. Such projects do not have source files nor tests, although they can have their own dependencies. Each child application must be defined inside the apps directory.

Let's move inside the apps directory and start building valuestorage_server. This time, we are going to pass the --sup flag, which will tell Mix to generate a supervision tree automatically for us, instead of building one manually as we did in previous lessons:

    $ cd valuestorage_umbrella/apps
    $ mix new valuestorage_server --module ValueStorageServer --sup

The generated files are similar to the ones we first generated for ValueStorage, with a few differences. Let's open up mix.exs:

    defmodule ValueStorageServer.MixProject do
        use Mix.Project

        def project do
            [
                app: :valuestorage_server,
                version: "0.1.0",
                build_path: "../../_build",
                config_path: "../../config/config.exs",
                deps_path: "../../deps",
                lockfile: "../../mix.lock",
                elixir: "~> 1.10",
                start_permanent: Mix.env() == :prod,
                deps: deps()
            ]
        end

        # Run "mix help compile.app" to learn about applications
        def application do
            [
                extra_applications: [:logger],
                mod: {ValueStorageServer.Application, []}
            ]
        end

        # Run "mix help deps" to learn about dependencies
        defp deps do
            [
                # {:dep_from_hexpm, "~> 0.3.0"},
                # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
                # {:sibling_app_in_umbrella, in_umbrella: true},
            ]
        end
    end

First of all, since we generated this project inside valuestorage_umbrella/apps, Mix automatically detected the umbrella structure and added four lines to the project definition:

    build_path: "../../_build",
    config_path: "../../config/config.exs",
    deps_path: "../../deps",
    lockfile: "../../mix.lock",

Those options mean all dependencies will be checked out to valuestorage_umbrella/deps, and they will share the same build, config and lock files. We haven't talked about configuration yet, but from here we can build the intuition that all configuration and dependencies are shared across all projects in an umbrella, and it is not per application.

The second change is in the application function inside mix.exs:

    def application do
        [
            extra_applications: [:logger],
            mod: {ValueStorageServer.Application, []}
        ]
    end

Because we passed the --sup flag, Mix automatically added mod: {ValueStorageServer.Application, []}, specifying that ValueStorageServer.Application is our application callback module. ValueStorageServer.Application will start our application supervision tree.

In fact, let's open up lib/valuestorage_server/application.ex:

    defmodule ValueStorageServer.Application do
        # See https://hexdocs.pm/elixir/Application.html
        # for more information on OTP Applications
        @moduledoc false

        use Application

        def start(_type, _args) do
            # List all child processes to be supervised
            children = [
                # Starts a worker by calling: ValueStorageServer.Worker.start_link(arg)
                # {ValueStorageServer.Worker, arg},
            ]

            # See https://hexdocs.pm/elixir/Supervisor.html
            # for other strategies and supported options
            opts = [strategy: :one_for_one, name: ValueStorageServer.Supervisor]
            Supervisor.start_link(children, opts)
        end
    end

Notice that it defines the application callback function, start/2, and instead of defining a supervisor named ValueStorageServer.Supervisor that uses the Supervisor module, it conveniently defined the supervisor inline! You can read more about such supervisors by reading the [Supervisor module documentation.](https://hexdocs.pm/elixir/Supervisor.html)

We can already try out our first umbrella child. We could run tests inside the apps/valuestorage_server directory, but that wouldn't be much fun. Instead, go to the root of the umbrella project and run mix test:

    $ mix test

Since we want valuestorage_server to eventually use the functionality we defined in ValueStorage, we need to add ValueStorage as a dependency to our application.


&nbsp;
### **Dependencies within an umbrella project**

Dependencies between applications in an umbrella project must still be explicitly defined and Mix makes it easy to do so. Open up apps/valuestorage_server/mix.exs and change the deps/0 function to the following:

    defp deps do
        [{:valuestorage, in_umbrella: true}]
    end

The line above makes :valuestorage available as a dependency inside :valuestorage_server and automatically starts the :valuestorage application before the server starts.

Finally, copy the ValueStorage application we have built so far to the apps directory in our new umbrella project. The final directory structure should match the structure we mentioned earlier:

    + valuestorage_umbrella
    + apps
        + valuestorage
        + valuestorage_server

We now need to modify apps/valuestorage/mix.exs to contain the umbrella entries we have seen in apps/valuestorage_server/mix.exs. Open up apps/valuestorage/mix.exs and add to the project/0 function:

    build_path: "../../_build",
    config_path: "../../config/config.exs",
    deps_path: "../../deps",
    lockfile: "../../mix.lock",

Now you can run tests for both projects from the umbrella root with mix test.


&nbsp;
### **Don't drink the kool aid**

Umbrella projects are a convenience to help you organize and manage multiple applications. While it provides a degree of separation between applications, those applications are not fully decoupled, as they share the same configuration and the same dependencies.

The pattern of keeping multiple applications in the same repository is known as *mono-repo*. Umbrella projects maximize this pattern by providing conveniences to compile, test and run multiple applications at once.

If you find yourself in a position where you want to use different configurations in each application for the same dependency or use different dependency versions, then it is likely your codebase has grown beyond what umbrellas can provide.

The good news is that breaking an umbrella apart is quite straightforward, as you simply need to move applications outside of the umbrella project's apps/ directory. In the worst case scenario, you can discard the umbrella project and all related configuration (build_path, config_path, deps_path and lockfile) and still leverage the *mono-repo* pattern by keeping all applications together in the same repository. Each application will have its own dependencies and configuration. Dependencies between those applications can still be explicitly listed by using the :path option (in contrast to :git).


&nbsp;
### **Summing up**

In this lesson, we have learned more about Mix dependencies and umbrella projects. While we may run ValueStorage without a server, our valuestorage_server depends directly on ValueStorage. By breaking them into separate applications, we gain more control in how they are developed and tested.

When using umbrella applications, it is important to have a clear boundary between them. Our upcoming valuestorage_server must only access public APIs defined in ValueStorage. Think of your umbrella apps as any other dependency or even Elixir itself: you can only access what is public and documented. Reaching into private functionality in your dependencies is a poor practice that will eventually cause your code to break when a new version is up.

Umbrella applications can also be used as a stepping stone for eventually extracting an application from your codebase. For example, imagine a web application that has to send *push notifications* to its users. The whole *push notifications system* can be developed as a separate application in the umbrella, with its own supervision tree and APIs. If you ever run into a situation where another project needs the push notifications system, the system can be moved to a private repository or a Hex package.

Developers may also use umbrella projects to break large business domains apart. The caution here is to make sure the domains don't depend on each other (also known as cyclic dependencies). If you run into such situations, it means those applications are not as isolated from each other as you originally thought, and you have architectural and design issues to solve.

Finally, keep in mind that applications in an umbrella project all share the same configurations and dependencies. If two applications in your umbrella need to configure the same dependency in drastically different ways or even use different versions, you have probably outgrown the benefits brought by umbrellas. Remember you can break the umbrella and still leverage the benefits behind *mono-repos*.


&nbsp;
----
**© Elixir-Lang.org, Jani Immonen**

