# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Chat application with Phoenix channels**
Another example of Phoenix in action is to use channels for direct socket communication between server and clients. In this lesson we will create a chat application. Use **mix** to create new Phoenix application. In directory where you want to create project to, run the command:

    $ mix phx.new chat
    * creating chat/config/config.exs
    * creating chat/config/dev.exs
    * creating chat/config/prod.exs
    * creating chat/config/prod.secret.exs
    ...
    * creating chat/assets/css/phoenix.css
    * creating chat/assets/static/images/phoenix.png
    * creating chat/assets/static/robots.txt

    Fetch and install dependencies? [Yn]

Type **Y** or press enter to download and install dependecies.

Go to the **chat** folder and create the database:

    $ cd chat
    $ mix ecto.create
    Compiling 14 files (.ex)
    Generated chat app
    The database for Chat.Repo has been created

> To change the database username or password, see **config/dev.exs** file.

Next, start the Phoenix server:

    $ mix phx.server

If you are running on Windows, the Windows Defender Firewall prompt may pop up. Allow connections on private networks.

Phoenix server is now running and is serving the web page in default port of 4000. Open the Phoenix welcome page in your browser at [http://localhost:4000](http://localhost:4000).

To stop the application, tap **ctrl+c** twice on command prompt.


&nbsp;
### **Channel endpoints**
Open the **lib/chat_web/endpoint.ex**. You will notice that the endpoint is already set up in there:

    defmodule ChatWeb.Endpoint do
        use Phoenix.Endpoint, otp_app: :chat

        socket "/socket", ChatWeb.UserSocket
        ...
    end

In **lib/chat_web/channels/user_socket.ex**, the ChatWeb.UserSocket we pointed to in our endpoint has already been created when we generated our application. We need to make sure messages get routed to the correct channel. To do that, we'll uncomment the *"room:*"* channel definition:

    defmodule ChatWeb.UserSocket do
        use Phoenix.Socket

        ## Channels
        channel "room:*", ChatWeb.RoomChannel
        ...

Now, whenever a client sends a message whose topic starts with "room:", it will be routed to our RoomChannel. Next, we'll define a ChatWeb.RoomChannel module to manage our chat room messages.


&nbsp;
### **Joining Channels**
The first priority of your channels is to authorize clients to join a given topic. For authorization, we must implement join/3 in **lib/chat_web/channels/room_channel.ex**.

    defmodule ChatWeb.RoomChannel do
        use Phoenix.Channel

        def join("room:lobby", _message, socket) do
            {:ok, socket}
        end

        def join("room:" <> _private_room_id, _params, _socket) do
            {:error, %{reason: "unauthorized"}}
        end
    end

For our chat app, we'll allow anyone to join the "room:lobby" topic, but any other room will be considered private and special authorization, say from a database, will be required. (We won't worry about private chat rooms for this exercise, but feel free to explore them).

To authorize the socket to join a topic, we return **{:ok, socket}** or **{:ok, reply, socket}**. To deny access, we return **{:error, reply}**. More information about authorization with tokens can be found in the [Phoenix.Token documentation](https://hexdocs.pm/phoenix/Phoenix.Token.html).

Phoenix projects come with [webpack](https://webpack.js.org/) by default, unless disabled with the --no-webpack option when you run **mix phx.new**.

The **assets/js/socket.js** defines a simple client based on the socket implementation that ships with Phoenix. We can use that library to connect to our socket and join our channel, we just need to set our room name to "room:lobby" in that file. Modify the line:

    //let channel = socket.channel("topic:subtopic", {})
    let channel = socket.channel("room:lobby", {})

After that, we need to make sure **assets/js/socket.js** gets imported into our application JavaScript file. To do that, add a new line to the end of **assets/js/app.js**:

    import socket from "./socket"

In **lib/chat_web/templates/page/index.html.eex**, replace all the existing code with a container to hold our chat messages, and an input field to send them:

    <div id="messages" role="log" aria-live="polite"></div>
    <input id="chat-input" type="text"></input>

Now, add a couple of event listeners to **assets/js/socket.js**. Replace the code below **socket.connect()** with:

    // ...
    let channel           = socket.channel("room:lobby", {})
    let chatInput         = document.querySelector("#chat-input")
    let messagesContainer = document.querySelector("#messages")

    chatInput.addEventListener("keypress", event => {
    if(event.key === 'Enter'){
        channel.push("new_msg", {body: chatInput.value})
        chatInput.value = ""
    }
    })

    channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

    export default socket

All we did was to detect that enter was pressed and then push an event over the channel with the message body. We named the event "new_msg". With this in place, let's handle the other piece of a chat application where we listen for new messages and append them to our messages container. Add new handler after the chatInput.addEventListener:

    channel.on("new_msg", payload => {
        let messageItem = document.createElement("p")
        messageItem.innerText = `[${Date()}] ${payload.body}`
        messagesContainer.appendChild(messageItem)
    })

Now we listen for the *"new_msg"* event using channel.on, and then append the message body to the DOM. Now let's handle the incoming and outgoing events on the server to complete the functionality.


&nbsp;
### **Incoming Events**
We handle incoming events with **handle_in/3**. We can pattern match on the event names, like *"new_msg"*, and then grab the payload that the client passed over the channel. For our chat application, we simply need to notify all other *room:lobby* subscribers of the new message with **broadcast!/3**.

    defmodule ChatWeb.RoomChannel do
        use Phoenix.Channel

        def join("room:lobby", _message, socket) do
            {:ok, socket}
        end
        def join("room:" <> _private_room_id, _params, _socket) do
            {:error, %{reason: "unauthorized"}}
        end

        def handle_in("new_msg", %{"body" => body}, socket) do
            broadcast!(socket, "new_msg", %{body: body})
            {:noreply, socket}
        end
    end

**broadcast!/3** will notify all joined clients on this socket's topic and invoke their **handle_out/3** callbacks. **handle_out/3** isn't a required callback, but it allows us to customize and filter broadcasts before they reach each client. By default, **handle_out/3** is implemented for us and simply pushes the message on to the client, just like our definition.

Now, fire up as many browser tabs/instances and try the chat app in practise.


&nbsp;
----
**© 2024 Jani Immonen**

