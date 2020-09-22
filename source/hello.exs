# Hello from Elixir example
defmodule Input do
  def get_string(str) do
    IO.gets(str) |> String.trim
  end
end

# use IO library 'puts' function to print text to the console
IO.puts "Hyvää Päivää!"
str = Input.get_string "Gimme number: "
number = String.to_integer(str)
IO.puts number
