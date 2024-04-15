# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Phoenix**
Phoenix is a web development framework written in Elixir which implements the server-side **Model View Controller (MVC)** pattern.

Many of Phoenix components and concepts will seem familiar to those of us with experience in other web frameworks like Ruby on Rails or Python's Django.

Phoenix provides the best of both worlds - high developer productivity and high application performance. It also has some interesting new twists like channels for implementing realtime features and pre-compiled templates for blazing speed.


&nbsp;
## **Model View Controller pattern**

![](./img/mvc.png "Model View Controller (MVC)"){ width=50% }

**Model**
- The central component of the pattern. It is the application's dynamic data structure, independent of the user interface. It directly manages the data, logic and rules of the application.

**View**
- Any representation of information such as a chart, diagram or table. Multiple views of the same information are possible, such as a bar chart for management and a tabular view for accountants.

**Controller**
- Accepts input and converts it to commands for the model or view.

In addition to dividing the application into these components, the model–view–controller design defines the interactions between them.
* The model is responsible for managing the data of the application. It receives user input from the controller.
* The view means presentation of the model in a particular format.
* The controller responds to the user input and performs interactions on the data model objects. The controller receives the input, optionally validates it and then passes the input to the model.


&nbsp;
### **Installation**
The **Hex package manager** is required to get Phoenix apps running. Hex installs and updates the project dependencies. Install (or update) Hex with:

    $ mix local.hex

Elixir 1.6 and Erlang 20 are the minimum requirements. Check your versions and update if necessary:

    $ elixir -v
    Erlang/OTP 21 [erts-10.3] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1]

    Elixir 1.10.4 (compiled with Erlang/OTP 21)

Next we will install the Phoenix application generator:

    $ mix archive.install hex phx_new


&nbsp;
### **node.js**
Phoenix uses webpack to compile static assets (JavaScript, CSS, etc), by default. Webpack uses the **node package manager (npm)** to install its dependencies, and npm requires node.js.

Download and install node.js from the [download page](https://nodejs.org/en/download/).

Then test that **npm** is installed and configured properly. Open command prompt and type:

    $ npm -v
    6.14.15

If npm does not work, you may need to set paths manually. Add the path **C:\\Program Files\\nodejs\\** to system environment variables:
- Win+Q and type "envi". Open the **Edit the system environment variables**
- On **Advanced** tab, click **Environment Variables...**
- Double click the **Path** user variable
- Click **New** and enter **C:\\Program Files\\nodejs\\** (the default node.js install location)
- Click **Ok** until all popups are closed


&nbsp;
### **PostgreSQL**
PostgreSQL is a relational database server. Phoenix configures applications to use it by default. Phoenix supports other database servers too bypassing **--database** flag when creating a new application.

> When installing for the purpose of this course, use password *postgres* for the admin user *postgres* as that is the default used by application created by **mix**.

Install the PostgreSQL from [download page](https://www.postgresql.org/download/). If needed, check the detailed [the installation guides](https://wiki.postgresql.org/wiki/Detailed_installation_guides) for your system.


&nbsp;
### **inotify-tools (for Linux users)**
Phoenix provides a feature called Live Reloading. As you change your views or your assets, it automatically reloads the page in the browser. In order for this functionality to work in Linux, you need a filesystem watcher.

Mac OS X and Windows users already have a filesystem watcher but Linux users need to install inotify-tools. Please consult the [inotify-tools wiki](https://github.com/rvoicilas/inotify-tools/wiki) for distribution-specific installation instructions.


&nbsp;
### **Linux install (quick list)**

    $ sudo apt install erlang-dev
    $ sudo apt install elixir
    $ sudo apt install npm
    $ sudo apt install nodejs
    $ sudo apt install postgresql

    $ sudo -u postgres -i
    $ createuser -l -d -P postgres
    $ [ENTER PASSWORD "postgres"]
    $ exit

    Download Visual Studio Code debian installation package
    $ sudo dpkg -i [VSCODE_PACKAGE_NAME]

    Install Phoenix 'new' tool
    $ mix archive.install hex phx_new
    

&nbsp;



&nbsp;
----
**© 2024 Jani Immonen**

