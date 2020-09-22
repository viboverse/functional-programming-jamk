# Hello from Elixir example
defmodule Input do
  def get_string(str) do
    IO.gets(str) |> String.trim
  end
end

number = 124

if number == 124 do
  IO.puts("Match #{number}")
else
  IO.puts("No match #{number}")
end

IO.puts "Hyvää Päivää!"
str = IO.gets("Gimme number: ")
str = String.trim(str)
number = String.to_integer(str)
IO.puts number

