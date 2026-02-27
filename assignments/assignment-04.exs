# Task 1

colors = [
  coral: "#FF7F50",
  blueViolet: "#8A2BE2",
  blue: "#0000FF",
  magenta: "#FF00FF",
  cyan: "#00FFFF",
  darkGreen: "#006400",
  darkBlue: "#00008B",
  gray: "#808080",
  yellow: "#FFFF00",
  red: "#FF0000",
]

loop = fn loop ->
  input = IO.gets("Enter color name or #hex: ") |> String.trim()

  cond do
    # If the res start with the #
    String.starts_with?(input, "#") ->
      result = Enum.find(colors, fn {_name, hex} -> hex == String.upcase(input) end)

      if result do
        {name, _hex} = result
        IO.puts("Color name: #{name}")
        loop.(loop)
      else
        IO.puts("Not found. Exiting.")
      end


    true ->
      key = String.downcase(input) |> String.to_atom()
      value = colors[key]

      if value do
        IO.puts("Hex value: #{value}")
        loop.(loop)
      else
        IO.puts("Not found. Exiting.")
      end
  end
end

loop.(loop)


# Task 2
books = %{
  "9789400515970" => "Atomic habits",
  "9798305312904" => "Animal Farm",
  "9780060883287" => "One Hundred Years of Solitude",
  "9780452262935" => "1984",
  "9781094659329" => "The Gambler"
}

loop2 = fn loop2, books ->
  input = IO.gets("Enter command (list, search, add, remove, quit): ") |> String.trim()

  cond do
    input == "list" ->
      IO.inspect(Map.to_list(books))
      loop2.(loop2, books)


     String.starts_with?(input, "search") ->
      isbn = String.replace(input, "search ", "")

      if books[isbn] do
        IO.puts("#{isbn} - #{books[isbn]}")
      else
        IO.puts("Not found.")
      end
      loop2.(loop2, books)


    String.starts_with?(input, "add") ->
      "add " <> newBook = input
      [isbn, name] = String.split(newBook, ",", parts: 2)
      updated = Map.put(books, isbn, name)
      IO.puts("Added!")
      loop2.(loop2, updated)

    String.starts_with?(input, "remove") ->
      "remove " <> isbn = input

      if books[isbn] do
        updated = Map.delete(books, isbn)
        IO.puts("Removed!")
        loop2.(loop2, updated)
      else
        IO.puts("Not found.")
        loop2.(loop2, books)
      end


    input == "quit" ->
      IO.puts("Quited!")
  end
end



loop2.(loop2, books)
