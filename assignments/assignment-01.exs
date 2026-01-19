# 1.1
foo = "Elixir"

# 1.2
IO.puts(foo)

# 1.3
user_input = String.trim(IO.gets("Say something:"))

# 1.4
concatedText = user_input <> "<- You said that"

# 1.5
IO.puts(concatedText)


# 2.1
divide_result = 154/ 78
IO.puts(divide_result)

# 2.2
rounded_res = round(divide_result)
IO.puts(rounded_res)

# 2.3
truncated_res = trunc(rounded_res)
IO.puts(truncated_res)

# 3.1
input_text = String.trim(IO.gets("Enter sth: "))

# 3.2
IO.puts("The Length of input text is: #{String.length(input_text)}")

# 3.3
reverse_text = String.reverse(input_text)
IO.puts(reverse_text)

# 3.4
IO.puts("Replaced: #{String.replace(input_text, "foo", "bar")}")


# 4.1
multiply = fn(a, b, c) -> a * b * c end

# 4.2
num1 = String.trim(IO.gets("Enter first number: ")) |> String.to_integer()
num2 = String.trim(IO.gets("Enter second number: ")) |> String.to_integer()
num3 = String.trim(IO.gets("Enter third number: ")) |> String.to_integer()

multiply_result = multiply.(num1, num2, num3)

# 4.3
IO.puts(multiply_result);

# 4.4
concat_list = fn(list1, list2) -> list1 ++ list2 end

# 4.5
concated_list = concat_list.([1,2], [3,4])
IO.inspect(concated_list)

# 4.6
tuple = {:ok, :fail}

# 4.7
new_tuple = Tuple.append(tuple, :canceled)
IO.inspect(new_tuple)
