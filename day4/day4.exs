stream = File.stream!("./input.txt")

defmodule Util do
  def list_to_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {char, i}, acc -> Map.put(acc, i, char) end)
  end
end

defmodule Part1 do
  def count_xmas(map, target) do
    rows = map_size(map)
    cols = map_size(map[0])

    Enum.reduce(0..(rows - 1), 0, fn row, acc ->
      Enum.reduce(0..(cols - 2), acc, fn col, acc ->
        acc + match_directions(map, target, row, col) +
          match_directions(map, String.reverse(target), row, col)
      end)
    end)
  end

  defp match_directions(map, target, row, col) do
    [:horizontal, :vertical, :diagonal_down, :diagonal_up]
    |> Enum.reduce(0, fn dir, acc ->
      if match_in_direction(map, target, row, col, dir) do
        acc + 1
      else
        acc + 0
      end
    end)
  end

  defp match_in_direction(map, target, row, col, :horizontal) do
    Enum.all?(0..(String.length(target) - 1), fn i ->
      Map.get(map[row], col + i) == String.at(target, i)
    end)
  end

  defp match_in_direction(map, target, row, col, :vertical) do
    Enum.all?(0..(String.length(target) - 1), fn i ->
      map[row + i] && Map.get(map[row + i], col) == String.at(target, i)
    end)
  end

  defp match_in_direction(map, target, row, col, :diagonal_down) do
    Enum.all?(0..(String.length(target) - 1), fn i ->
      map[row + i] && Map.get(map[row + i], col + i) == String.at(target, i)
    end)
  end

  defp match_in_direction(map, target, row, col, :diagonal_up) do
    Enum.all?(0..(String.length(target) - 1), fn i ->
      map[row - i] && Map.get(map[row - i], col + i) == String.at(target, i)
    end)
  end
end

defmodule Part2 do
  def count_xmas(map) do
    rows = map_size(map)
    cols = map_size(map[0])

    Enum.reduce(1..(rows - 2), 0, fn row, acc ->
      Enum.reduce(1..(cols - 3), acc, fn col, acc ->
        acc + find_xmas(map, row, col)
      end)
    end)
  end

  defp find_xmas(map, row, col) do
    center = Map.get(map[row], col)
    tl = Map.get(map[row - 1], col - 1)
    bl = Map.get(map[row - 1], col + 1)
    tr = Map.get(map[row + 1], col - 1)
    br = Map.get(map[row + 1], col + 1)

    if center == "A" do
      case {tl, bl, tr, br} do
        {"M", "M", "S", "S"} -> 1
        {"M", "S", "M", "S"} -> 1
        {"S", "S", "M", "M"} -> 1
        {"S", "M", "S", "M"} -> 1
        _ -> 0
      end
    else
      0
    end
  end
end

map =
  stream
  |> Enum.map(fn line ->
    String.graphemes(line)
    |> Util.list_to_map()
  end)
  |> Util.list_to_map()

part1 = Part1.count_xmas(map, "XMAS")
part2 = Part2.count_xmas(map)

IO.puts("part 1: #{part1}")
IO.puts("part 2: #{part2}")
