defmodule Calculator do
  def calc(input) do

    parts = Regex.split(~r/([+\-*\/])/, input, include_captures: true)

    case parts do
      [a, operation, b] ->

        num1 = String.to_integer(a)
        num2 = String.to_integer(b)


        case operation do
          "+" -> Math.add(num1, num2)
          "-" -> Math.sub(num1, num2)
          "*" -> Math.mul(num1, num2)
          "/" -> Math.div(num1, num2)
        end

    end
  end
end
