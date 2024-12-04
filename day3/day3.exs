defmodule CorruptedMemory do
  defp scan_muls(contents) do
    Regex.scan(~r/mul\(\d+,\d+\)/, contents)
  end

  defp scan_do_muls(contents) do
    Regex.scan(~r/(do\(\))?.*?(mul\(\d+,\d+\))/, contents)
    |> Enum.filter(fn [full_match, _do, _mul] ->
      not String.contains?(full_match, "don't()")
    end)

    # |> Enum.count()
  end

  defp get_nums_sublist(mul) do
    Regex.scan(~r/\d+/, mul)
    |> List.flatten()
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_nums(mul) do
    mul |> hd |> get_nums_sublist()
  end

  def part1(contents) do
    contents
    |> scan_muls()
    |> Enum.map(&get_nums(&1))
    |> Enum.reduce(0, fn [a, b], acc -> acc + a * b end)
  end

  def part2(contents) do
    contents
    |> scan_do_muls()

    # |> List.flatten()
    |> Enum.reduce("", fn a, b -> a <> b end)
    |> part1()
  end
end

contents = File.read!("./input.txt") |> String.replace("\n", "")

part1 = CorruptedMemory.part1(contents)

IO.inspect(part1)

# part2 =
#   Regex.scan(~r/(?:do\(\))?(?:(?!don't).)*?mul\(\d+,\d+\)/, contents)
#   |> Enum.map(fn [x] -> Regex.scan(~r/mul\(\d+,\d+\)/, x) |> hd end)

# |> Enum.map(fn [x] ->
#   Regex.scan(~r/\d+/, x)
#   |> List.flatten()
#   |> Enum.map(&String.to_integer(&1))
# end)

# |> Enum.map(fn x ->
#   Regex.scan(
#     ~r/\d+/,
#     hd(x)
#   )
#   |> List.flatten()
#   |> Enum.map(&String.to_integer(&1))
# end)
# |> Enum.reduce(0, fn [a, b], acc -> acc + a * b end)

part2 = CorruptedMemory.part2(contents)
IO.inspect(part2)
