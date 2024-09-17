# **Functional Programming**
jani.immonen@jamk.fi


&nbsp;
## **Conditions**
In this lesson, we will learn about the case, cond, and if control flow structures. Create new file **conditions.exs** for these examples.

&nbsp;
### **case**
**case** allows us to compare a value against many patterns until we find a matching one:

    case {1, 2, 3} do
        {4, 5, 6} -> IO.puts("This clause won't match")
        {1, x, 3} -> IO.puts("This clause will match and bind x to #{x} in this clause")
        _ -> IO.puts("This clause would match any value")
    end

    "This clause will match and bind x to 2 in this clause"

If you want to pattern match against an existing variable, you need to use the **^** operator:

    x = 1
    case 10 do
        ^x -> IO.puts("Won't match. x=#{x}")
        _ -> IO.puts("Will match anything")
    end

    "Will match anything"

Clauses also allow extra conditions to be specified via guards:

    case {1, 2, 3} do
        {1, x, 3} when x > 0 -> IO.puts("Will match")
        _ -> IO.puts("Would match, if guard condition were not satisfied")
    end
    
    "Will match"

The first clause above will only match when **x** is positive.

Keep in mind runtime errors in guards do not crash the app but simply make the guard fail:

    # hd causes argument error on numeric variable, but
    # do not cause error on condition guard if guard is not true
    hd([1])
    case 1 do
        x when hd(x) == 1 -> IO.puts("Won't match")
        x -> IO.puts("Got #{x}")
    end
    
    "Got 1"

If none of the clauses match, an error is raised:

    case :ok do
        :error -> IO.puts("Won't match")
    end
    
    ** (CaseClauseError) no case clause matching: :ok

Consult the full documentation for guards for more information about guards, how they are used, and what expressions are allowed in them.

Note anonymous functions can also have multiple clauses and guards:

    f = fn(x, y) when x > 0 -> x + y
        (x, y) -> x * y
    end

    IO.puts(f.(1, 3))
    IO.puts(f.(-1, 3))

    4
    -3

The number of arguments in each anonymous function clause needs to be the same, otherwise an error is raised.

    f2 = fn(x, y) when x > 0 -> x + y
        (x, y, z) -> x * y + z
    end

    ** (CompileError) iex:1: cannot mix clauses with different arities in anonymous functions

&nbsp;
### **cond**
**case** is useful when you need to match against different values. However, in many circumstances, we want to check different conditions and find the first one that does not evaluate to *nil* or *false*. In such cases, one may use **cond**:

    cond do
        2 + 2 == 5 -> IO.puts("This will not be true")
        2 * 2 == 3 -> IO.puts("Nor this")
        1 + 1 == 2 -> IO.puts("But this will")
    end
    
    "But this will"

This is equivalent to else if clauses in many imperative languages, although used way less frequently in Elixir.

If all of the conditions return *nil* or *false*, an error (*CondClauseError*) is raised. For this reason, it may be necessary to add a final condition, equal to **true**, which will always match:

    cond do
        2 + 2 == 5 -> IO.puts("This is never true")
        2 * 2 == 3 -> IO.puts("Nor this")
        true -> IO.puts("This is always true (equivalent to else)")
    end

    "This is always true (equivalent to else)"

Finally, note **cond** considers any value besides *nil* and *false* to be true:

    cond do
        hd([1, 2, 3]) -> IO.puts("1 is considered as true")
    end
    
    "1 is considered as true"

&nbsp;
### **if and unless**
Besides **case** and **cond**, Elixir also provides the macros **if/2** and **unless/2** which are useful when you need to check for only one condition:

    if true do
        IO.puts("This works!")
    end

    "This works!"

    unless true do
        IO.puts("This will never be seen")
    end

If the condition given to **if/2** returns *false* or *nil*, the body given between *do/end* is not executed and instead it returns *nil*. The opposite happens with **unless/2**.

They also support else blocks:

    if nil do
        IO.puts("This won't be seen")
    else
        IO.puts("This will")
    end
    
    "This will"

*Note: An interesting note regarding if/2 and unless/2 is that they are implemented as macros in the language; they aren't special language constructs as they would be in many languages. You can check the documentation and the source of if/2 in the Kernel module docs. The Kernel module is also where operators like +/2 and functions like is_function/2 are defined, all automatically imported and available in your code by default.*

&nbsp;
### **do/end blocks**
At this point, we have learned four control structures: **case**, **cond**, **if**, and **unless**, and they were all wrapped in *do/end* blocks. It happens we could also write if as follows:

    if true, do: IO.puts(1 + 2)
    
    3

Notice how the example above has a comma between *true* and *do:*, that's because it is using Elixir's regular syntax where each argument is separated by a comma. We say this syntax is using keyword lists. We can pass else using keywords too:

    if false, do: IO.puts(:this), else: IO.puts(:that)
    
    :that

*do/end* blocks are a syntactic convenience built on top of the keywords. That's why *do/end* blocks do not require a comma between the previous argument and the block. They are useful exactly because they remove the verbosity when writing blocks of code. These are equivalent:

    if true do
        a = 1 + 2
        a = a + 10
        IO.puts(a)
    end

    13

    if true, do: (
        a = 1 + 2
        a = a + 10
    )

    13

One thing to keep in mind when using do/end blocks is they are always bound to the outermost function call. For example, the following expression:

    is_number if true do
        IO.puts(1 + 2)
    end
    
    ** (CompileError) iex:1: undefined function is_number/2
    
Would be parsed as:

    is_number(if true) do
        IO.puts 1 + 2
    end

    ** (CompileError) iex:1: undefined function is_number/2

which leads to an undefined function error because that invocation passes two arguments, and **is_number/2** does not exist. The if true expression is invalid in itself because it needs the block, but since the arity of **is_number/2** does not match, Elixir does not even reach its evaluation.

Adding explicit parentheses is enough to bind the block to if:

    is_number(if true do
        IO.puts 1 + 3
    end)

    4

&nbsp;
----
**© Elixir-Lang.org, Jani Immonen**

