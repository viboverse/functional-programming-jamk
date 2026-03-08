defmodule Math do

  # Private Function
  defp info(operatiom, a, b) do
    IO.puts("#{operatiom} #{a} and #{b}")
  end

  # Public functions
  def add(a, b) do
    info("Adding", a, b)
    a + b
  end

  def sub(a, b) do
    info("Subtracting", a, b)
    a - b
  end

  def mul(a, b) do
    info("Multiplying", a, b)
    a * b
  end

  def div(a, b) do
    info("Dividing", a, b)
    a / b
  end

end
