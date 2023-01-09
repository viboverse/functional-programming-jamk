defmodule Recursion do
  def loop(msg, n, c) do
    IO.puts msg <> to_string(n)
    if n < c do loop(msg, n + 1, c) end
  end
end

Recursion.loop("Step ", 1, 5)


"""
Stuff worth mentioning:
- Exception handling
- Supervisors
- Dynamic Supervisors
- Supervision Trees

Also worth mentioning:
- Pure functions do not alter external state/data/variables

"""

Enum.each(1..5, fn(x) ->
  IO.write "step"
  IO.puts x
end)
