stream = File.stream!("./input.txt")

list =
  stream
  |> Enum.map(fn line -> String.split(line, " ") end)
  |> List.flatten()
  |> Enum.filter(fn x -> x != "" end)
  |> Enum.map(fn number ->
    number
    |> String.trim()
    |> String.to_integer()
  end)

first =
  list
  |> Enum.take_every(2)
  |> Enum.sort()

second =
  list
  |> tl
  |> Enum.take_every(2)
  |> Enum.sort()

total_distance =
  Enum.zip([first, second])
  |> Enum.map(fn {first, second} -> abs(first - second) end)
  |> Enum.reduce(0, fn a, b -> a + b end)

similarity_score =
  first
  |> Enum.map(fn x -> x * Enum.count(second, fn y -> x == y end) end)
  |> Enum.reduce(0, fn x, y -> x + y end)

IO.puts("total distance: #{total_distance}")
IO.puts("similarity score: #{similarity_score}")
