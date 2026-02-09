# Part I
user_input = String.trim(IO.gets("Enter A Number: ")) |> String.to_integer()

cond do
  rem(user_input, 3) == 0 ->
    IO.puts("#{user_input} is Divisible by 3")
  rem(user_input, 5) == 0 ->
    IO.puts("#{user_input} is Divisible by 5")
  rem(user_input, 7) == 0 ->
    IO.puts("#{user_input} is Divisible by 7")
  true ->
    smallest_divisor = Enum.find(2..user_input, fn x -> rem(user_input, x) == 0 end)

    IO.puts("The Smallest Diviser: #{smallest_divisor}")
end


# Part II

result = fn a,b ->
cond do
   is_binary(a) and is_binary(b) ->
    a <> b
  is_integer(a) and is_integer(b) ->
    a + b
end
end

IO.puts(result.("Lazy", "Bee"))
IO.puts(result.(4,6))
