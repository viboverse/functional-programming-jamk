# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Structs**
In [previous lesson](./09-keyword-list-and-map.md) we learned about maps:

    iex> map = %{a: 1, b: 2}
    %{a: 1, b: 2}
    iex> map[:a]
    1
    iex> %{map | a: 3}
    %{a: 3, b: 2}

Structs are extensions built on top of maps that provide compile-time checks and default values.

&nbsp;
### **Defining structs**
To define a struct, the defstruct construct is used. Create a new file **modules.ex** and define a struct:

    defmodule User do
        defstruct name: "John", age: 27
    end

The keyword list used with defstruct defines what fields the struct will have along with their default values.

Structs take the name of the module they're defined in. In the example above, we defined a struct named User.

Compile the **modules.ex** with *elixirc modules.ex*. Then create new script file to same directory called **test.exs**. We can now create User structs by using a syntax similar to the one used to create maps. In **test.exs**:

    IO.inspect(%User{})
    IO.inspect(%User{name: "Jane"})

Output:

    %User{age: 27, name: "John"}
    %User{age: 27, name: "Jane"}

Structs provide compile-time guarantees that only the fields (and all of them) defined through defstruct will be allowed to exist in a struct:

    IO.inspect(%User{oops: :field})
    ** (KeyError) key :oops not found in: %User{age: 27, name: "John"}

&nbsp;
### **Accessing and updating structs**
When we discussed maps, we showed how we can access and update the fields of a map. The same techniques (and the same syntax) apply to structs as well:

    john = %User{}
    IO.puts(john.name)
    jane = %{john | name: "Jane"}
    IO.puts(%{jane | oops: :field})
    ** (KeyError) key :oops not found in: %User{age: 27, name: "Jane"}

When using the update syntax (|), the VM is aware that no new keys will be added to the struct, allowing the maps underneath to share their structure in memory. In the example above, both john and jane share the same key structure in memory.

Structs can also be used in pattern matching, both for matching on the value of specific keys as well as for ensuring that the matching value is a struct of the same type as the matched value.

    %User{name: name} = john
    IO.puts(name)
    IO.inspect(%User{} = %{})
    ** (MatchError) no match of right hand side value: %{}

&nbsp;
### **Structs are bare maps underneath**
In the example above, pattern matching works because underneath structs are bare maps with a fixed set of fields. As maps, structs store a *special* field named __struct__ that holds the name of the struct:

    IO.puts(is_map(john))
    IO.puts(john.__struct__)

Notice that we referred to structs as bare maps because none of the protocols implemented for maps are available for structs. For example, you can neither enumerate nor access a struct:

    john = %User{}
    john[:name]
    ** (UndefinedFunctionError) function User.fetch/2 is undefined (User does not implement the Access behaviour)
                User.fetch(%User{age: 27, name: "John"}, :name)
    Enum.each john, fn({field, value}) -> IO.puts(value) end
    ** (Protocol.UndefinedError) protocol Enumerable not implemented for %User{age: 27, name: "John"}

However, since structs are just maps, they work with the functions from the Map module:

    jane = Map.put(%User{}, :name, "Jane")
    IO.inspect(jane)
    IO.inspect(Map.merge(jane, %User{name: "John"}))
    IO.inspect(Map.keys(jane))

Structs alongside protocols provide one of the most important features for Elixir developers: data polymorphism. That we will explore in the future lessons.

&nbsp;
### **Default values and required keys**
Back to **modules.ex**. If you don't specify a default key value when defining a struct, nil will be assumed:

    defmodule Product do
        defstruct [:name]
    end
    
And in *test.exs*

    IO.inspect(%Product{})

You can define a structure combining both fields with explicit default values, and implicit nil values. In this case you must first specify the fields which implicitly default to nil:

    defmodule User do
        defstruct [:email, name: "John", age: 27]
    end
    
And in *test.exs*
    
    IO.inspect(%User{})

Doing it in reverse order will raise a syntax error:

    defmodule User do                          
        defstruct [name: "John", age: 27, :email]
    end
    ** (SyntaxError) iex:107: syntax error before: email

You can also enforce that certain keys have to be specified when creating the struct:

    defmodule Car do
        @enforce_keys [:make]
        defstruct [:model, :make]
    end
    
test.exs:
    
    IO.inspect(%Car{})
    ** (ArgumentError) the following keys must also be given when building struct Car: [:make]
        expanding struct: Car.__struct__/1


&nbsp;
----
**© Elixir-Lang.org, Jani Immonen**

