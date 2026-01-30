# 1
x = 42
IO.puts(x)

^x = 42
# ^x = 41

# 2
list = [1,2,3,4]

[first | _] = list
[first, second | _] = list

IO.puts(first)
IO.puts(second)
