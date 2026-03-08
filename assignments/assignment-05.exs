# Load the modules from the .ex files (AI helped to figure out Code.require_file)
Code.require_file("math.ex", __DIR__)
Code.require_file("calculator.ex", __DIR__)

loop = fn loop ->
  input = IO.gets("Enter calculation (e.g. 123+456): ") |> String.trim()

  result = Calculator.calc(input)

  case result do
    :error ->
      IO.puts("Invalid input. Exiting.")

    value ->
      IO.puts("Result: #{value}")
      loop.(loop)
  end
end

loop.(loop)
