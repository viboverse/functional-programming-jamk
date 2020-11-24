# **Functional Programming**
Jani Immonen, D571
jani.immonen@jamk.fi


&nbsp;
## **First Phoenix application**
Lets create a web application that has a countdown until holiday. Use **mix** to create new Phoenix application. In directory where you want to create project to, run the command:

    $ mix phx.new holiday
    * creating holiday/config/config.exs
    * creating holiday/config/dev.exs
    * creating holiday/config/prod.exs
    * creating holiday/config/prod.secret.exs
    ...
    * creating holiday/assets/css/phoenix.css
    * creating holiday/assets/static/images/phoenix.png
    * creating holiday/assets/static/robots.txt

    Fetch and install dependencies? [Yn]

Type **Y** or press enter to download and install dependecies. After install is complete, some additional instructions are printed into the console.

> If you get errors while installing dependencies, check the previous lesson for installing and setting up required software.

Go to the **holiday** folder and create the database:

    $ cd holiday
    $ mix ecto.create
    Compiling 14 files (.ex)
    Generated holiday app
    The database for Holiday.Repo has been created

To change the database username or password, see **config/dev.exs** file:

    # Configure your database
    config :holiday, Holiday.Repo,
        username: "postgres",
        password: "postgres",
        database: "holiday_dev",
        hostname: "localhost",
        show_sensitive_data_on_connection_error: true,
        pool_size: 10

Next, start the Phoenix server:

    $ mix phx.server

If you are running on Windows, the Windows Defender Firewall prompt may pop up. Allow connections on private networks.

Phoenix server is now running and is serving the web page in default port of 4000. Open the Phoenix welcome page in your browser at [http://localhost:4000](http://localhost:4000).

To stop the application, tap **ctrl+c** twice on command prompt.


&nbsp;
### **Directory structure**
Lets have a quick overview of generated files.

* **_build** - a directory created by the mix command line tool that ships as part of Elixir that holds all compilation artefacts. This directory must not be checked into version control and it can be removed at any time. Removing it will force Mix to rebuild your application from scratch.

* **assets** - a directory that keeps everything related to front-end assets, such as JavaScript, CSS, static images and more. It is typically handled by the **npm** tool. Phoenix developers typically only need to run **npm install** inside the assets directory. Everything else is managed by Phoenix.

* **config** - a directory that holds your project configuration. The **config/config.exs** file is the main entry point for your configuration. At the end of the **config/config.exs**, it imports environment specific configuration, which can be found in **config/dev.exs**, **config/test.exs**, and **config/prod.exs** for development, testing and production configurations.

* **deps** - a directory with all of our Mix dependencies. All dependencies are listed in the **mix.exs** file, inside the def deps do function definition. This directory must not be checked into version control and it can be removed at any time. Removing it will force Mix to download all dependencies.

* **lib** - a directory that holds your application source code.
    * **lib/holiday** directory will be responsible to host all of your business logic and business domain. It typically interacts directly with the database - it is the **Model** in **Model-View-Controller (MVC)** architecture.
    * **lib/holiday_web** is responsible for exposing your business domain to the world, in this case, through a web application. It holds both the **View** and **Controller** from MVC.

* **priv** - a directory that keeps all assets that are necessary in production but are not directly part of your source code. You typically keep database scripts, translation files, and more in here.

* **test** - a directory with all of our application tests. It often mirrors the same structure found in **lib** directory.


&nbsp;
### **The Model (lib/holiday)**
The **lib/holiday** directory hosts all of your business domain. Since our project does not have any business logic yet, the directory is mostly empty. You will only find two files:

>lib/holiday/application.ex

>lib/holiday/repo.ex

The **lib/holiday/application.ex** file defines an Elixir application named *Holiday.Application*. The *Holiday.Application* module defines which services are part of our application:

    children = [
        # Start the Ecto repository
        Holiday.Repo,
        # Start the Telemetry supervisor
        HolidayWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Holiday.PubSub},
        # Start the Endpoint (http/https)
        HolidayWeb.Endpoint
        # Start a worker by calling: Holiday.Worker.start_link(arg)
        # {Holiday.Worker, arg}
    ]

Application starts a **database repository (Holiday.Repo)**, a **pubsub system (Phoenix.PubSub)** for sharing messages across processes and nodes, and the **application endpoint (HolidayWeb.Endpoint)**, which effectively serves the HTTP requests. These services are started in the order they are defined and, whenever shutting down your application, they are stopped in the reverse order.

In the same **lib/holiday** directory, we will find a **lib/holiday/repo.ex**. It defines a *Holiday.Repo* module which is our main interface to the database. When using Postgres (the default), you will see something like this:

    defmodule Holiday.Repo do
    use Ecto.Repo,
        otp_app: :holiday,
        adapter: Ecto.Adapters.Postgres
    end


&nbsp;
### **The View and Controller (lib/holiday_web)**
The **lib/holiday_web** directory holds the web-related parts of the application. It looks like this when expanded:

    lib/holiday_web
    ├── channels
    │   └── user_socket.ex
    ├── controllers
    │   └── page_controller.ex
    ├── templates
    │   ├── layout
    │   │   └── app.html.eex
    │   └── page
    │       └── index.html.eex
    ├── views
    │   ├── error_helpers.ex
    │   ├── error_view.ex
    │   ├── layout_view.ex
    │   └── page_view.ex
    ├── endpoint.ex
    ├── gettext.ex
    ├── router.ex
    └── telemetry.ex

All of the files which are currently in the **controllers**, **templates**, and **views** directories are there to create the *Welcome to Phoenix!* page. The **channels** directory is where we will add code related to building real-time Phoenix applications.

By looking at **templates** and **views** directories, we can see Phoenix provides features for handling layouts and error pages out of the box.

Besides the directories mentioned, **lib/holiday_web** has four files at its root.
* **lib/holiday_web/endpoint.ex** is the entry-point for HTTP requests. Once the browser accesses [http://localhost:4000](http://localhost:4000), the endpoint starts processing the data, eventually leading to the router, which is defined in:
* **lib/holiday_web/router.ex** The router defines the rules to dispatch requests to *controllers*, which then uses *views* and *templates* to render HTML pages back to clients.
* **lib/holiday_web/telemetry.ex** Through [*telemetry*](https://hexdocs.pm/phoenix/telemetry.html), Phoenix is able to collect metrics and send monitoring events of the application. This file defines the supervisor responsible for managing the telemetry processes.
* **lib/holiday_web/gettext.ex** file which provides localization through [*Gettext* module](https://hexdocs.pm/gettext/Gettext.html).


&nbsp;
### **Holiday counter**
Lets add a simple counter that shows time remaining until holiday season starts. For this, we need to be able to store the events for the counter. Give a command:

    $ mix phx.gen.html Events Event events title due:datetime

The above command will create model, view, controllers, repository, templates, tests with basic **CRUD (Create,Read,Update,Delete)** events that connect to our database. The parameters to **mix phx.gen.html** specify the names as a *collection*, *singular* and *plural*, and lastly the database field names with types.

Next, edit the **lib/holiday_web/router.ex** and add the *resources* specification inside the *HolidayWeb* scope:

    scope "/", HolidayWeb do
        pipe_through :browser

        get "/", PageController, :index
        resources "/events", EventController
    end

Now we can migrate our new model to the database:

    $ mix ecto.migrate

And re-run our server:

    $ mix phx.server

Now the **events** subfolder is served by the Phoenix, open it in your web browser: [http://localhost:4000/events](http://localhost:4000/events).

Lets use the web interface to create new event called *Holiday* and set the due date when your next holiday starts. By default, all events are shown in main page, but as we are going to create a countdown clock, lets show only the future events. Open the **lib/holiday/events.ex** file for editing and add new function below *list_events*:

    @doc """
    Returns the list of future events.

    ## Examples

        iex> list_future_events()
        [%Event{}, ...]

    """
    def list_future_events do
        query = from e in Holiday.Events.Event,
        where: e.due >= ^DateTime.utc_now
        Repo.all(query)
    end

Next, we add this to the controller and display some items on the homepage. Let's edit our homepage controller at **lib/holiday_web/controllers/page_controller.ex**. Add the line **alias Holiday.Events** and modify *index* function accordingly:

    defmodule HolidayWeb.PageController do
        use HolidayWeb, :controller
        alias Holiday.Events

        def index(conn, _params) do
            events = Events.list_future_events()
            # render(conn, "index.html")
            render conn, "index.html", events: events
        end
    end

Now we need to edit our homepage template at **lib/holiday_web/templates/page/index.html.eex**. Replace the contents with following:

    <section class="phx-hero">
        <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
        <p>Peace of mind from prototype to production</p>
    </section>

    <ul>
        <%= for event <- @events do %>
            <li><%= event.title %>, <%= event.due %></li>
        <% end %>
    </ul>

Now our webpage shows a simple list of future events. You can verify this by adding another event that is due in past. Open [http://localhost:4000/events](http://localhost:4000/events) and create another event. Then return to the main page to verify that it is not visible there.


&nbsp;
### **Adding a clock**
We are going to use FlipClock.js to create our countdown clocks. Open the file **lib/holiday_web/templates/layout/app.html.eex** for editing and add following stylesheet and scripts:

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flipclock/0.7.8/flipclock.min.css" />
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flipclock/0.7.8/flipclock.min.js"></script>

We also need to edit the index page template to apply the countdown clock to the page. Replace the contents of the **lib/holiday_web/templates/page/index.html.eex** with:

    <%= for event <- @events do %>
        <div class="jumbotron">
        <span class="h1">Days until <%= event.title %></span>
        <p class="text-center"><span class="countdownClock" data-due="<%= event.due %>"></span></p>
        </div>
    <% end %>
    <script>
    $(document).ready(function() {
        $('.countdownClock').each(function(i, el) {
        var today = new Date();
        var due = new Date($(el).data('due'));
        $(el).FlipClock((due/1000) - (today/1000), {
            clockFace: 'DailyCounter',
                countdown: true,
                showSeconds: false
        });
        });
    });
    </script>

Just couple of more styling modifications; Center the clock and replace the Phoenix logo with our own. Open **assets/css/app.scss** and add:

    .jumbotron .flip-clock-wrapper {
        text-align: center;
        position: relative;
        width: auto;
        margin-top: 8em;
        display: inline-block;
    }

And lastly, download your favorite holiday image and place it into **assets/static/images/** directory. This example is assuming file is named *holiday.jpg*, use the filename of your own file. Open **lib/holiday_web/templates/layout/app.html.eex** and change the logo image path:

    <a href="https://phoenixframework.org/" class="phx-logo">
        <img src="<%= Routes.static_path(@conn, "/images/holiday.jpg") %>" alt="Time until holiday"/>
    </a>

> Note that Phoenix server needs to be restarted when static assets are updated.



&nbsp;
----
**© Jani Immonen**

