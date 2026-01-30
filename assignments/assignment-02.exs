# 1
calculate_string_count = fn(string) -> length(String.split(string)) end

text = "99 bottles of beer on the wall"

count = calculate_string_count.(text)

IO.puts("Words counts is #{count}")

# 2

phrase = "Pattern Matching with Elixir. Remember that equals sign is a match operator, not an assignment"


to_pig_latin = fn(text) ->
  text
  |> String.downcase()
  |> String.split()
  |> Enum.map_join(" ", fn word ->
    cond do
      # Rule 1: Starts with vowel or special vowel groups (yt, xr)
      String.starts_with?(word, ["a", "e", "i", "o", "u", "yt", "xr"]) ->
        word <> "ay"

      # Rule 2: Special consonant groups (longer ones first!)
      String.starts_with?(word, ["squ", "sch", "thr"]) ->
        {prefix, rest} = String.split_at(word, 3)
        rest <> prefix <> "ay"

      # Rule 3: 2-letter consonant groups
      String.starts_with?(word, ["th", "qu", "ch"]) ->
        {prefix, rest} = String.split_at(word, 2)
        rest <> prefix <> "ay"

      # Rule 4: Single consonant
      true ->
        {prefix, rest} = String.split_at(word, 1)
        rest <> prefix <> "ay"
    end
  end)
end

IO.puts to_pig_latin.(phrase)
