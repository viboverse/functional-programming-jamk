case {1, 2, 3} do
    {1, x, 3} when x > 0 -> IO.puts "Match"
    _ -> IO.puts "No match"
end

case 1 do
    x when hd(x) -> IO.puts "Won't match"
    x -> IO.puts "Got #{x}"
end

case :ok do
    :error -> IO.puts "Won't match"
    _ -> IO.puts "OK"
end

f = fn
    x, y when x > 0 -> x + y
    x, y -> x * y
end

IO.puts f.(30, 3)
IO.puts f.(-10, 3)


cond do
    2 + 2 == 5 -> IO.puts "This will not be true"
    2 * 2 == 3 -> IO.puts "Nor this"
    #1 + 1 == 2 -> IO.puts "But this will"
    true -> IO.puts "True"
end

cond do
    hd([1, 2, 3]) -> IO.puts "1 is considered as true"
end


x = 11
if x > 10 do
    IO.puts "x > 10"
else
    IO.puts "x is not greater than 10"
end

unless x != 10 do
    IO.puts "unless x != 10"
else
    IO.puts "unless else"
end

if true, do: IO.puts 1 + 2

if false, do: IO.puts(:this), else: IO.puts(:that)

if true do
    a = 1 + 2
    a = a + 10
    IO.puts a
end

if true, do: (
    a = 1 + 2
    a = a + 10
    IO.puts a
)

is_number(if true do
    IO.puts 1 + 3
end)

