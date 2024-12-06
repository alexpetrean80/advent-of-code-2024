defmodule Util do
  def list_to_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {char, i}, acc -> Map.put(acc, i, char) end)
  end
end

defmodule Day6 do
  def find_guard_pos_and_direction(map) do
    rows = map_size(map)
    cols = map_size(map[0])

    Enum.map(0..(rows - 1), fn row ->
      Enum.map(0..(cols - 2), fn col ->
        line = Map.get(map, row)
        el = Map.get(line, col)

        case el do
          ">" -> {row, col, :left}
          "<" -> {row, col, :right}
          "^" -> {row, col, :up}
          "v" -> {row, col, :down}
          _ -> nil
        end
      end)
      |> Enum.filter(fn x -> x != nil end)
    end)
    |> Enum.find(fn x -> x != [] end)
    |> List.first()
  end
end

defmodule Day6.Part1 do
  def move_guard(map, row, col, :up) do
    line = Map.get(map, row)

    if row - 1 == -1 do
      map
      |> Map.put(row, Map.put(line, col, "X"))
    else
      up_line = Map.get(map, row - 1)

      if Map.get(up_line, col) == "#" do
        map
        |> Map.put(row, Map.put(line, col, ">"))
        |> move_guard(row, col, :right)
      else
        map
        |> Map.put(row - 1, Map.put(up_line, col, "^"))
        |> Map.put(row, Map.put(line, col, "X"))
        |> move_guard(row - 1, col, :up)
      end
    end
  end

  def move_guard(map, row, col, :down) do
    line = Map.get(map, row)

    if row + 1 > map_size(map) - 1 do
      map
      |> Map.put(row, Map.put(line, col, "X"))
    else
      down_line = Map.get(map, row + 1)

      if Map.get(down_line, col) == "#" do
        map
        |> Map.put(row, Map.put(line, col, "<"))
        |> move_guard(row, col, :left)
      else
        map
        |> Map.put(row + 1, Map.put(down_line, col, "v"))
        |> Map.put(row, Map.put(line, col, "X"))
        |> move_guard(row + 1, col, :down)
      end
    end
  end

  def move_guard(map, row, col, :right) do
    line = Map.get(map, row)

    if col == map_size(line) - 1 do
      map
      |> Map.put(row, Map.put(line, col, "X"))
    else
      if Map.get(line, col + 1) == "#" do
        map
        |> Map.put(row, Map.put(line, col, "v"))
        |> move_guard(row, col, :down)
      else
        map
        |> Map.put(row, Map.put(line, col + 1, ">"))
        |> Map.put(row, Map.put(line, col, "X"))
        |> move_guard(row, col + 1, :right)
      end
    end
  end

  def move_guard(map, row, col, :left) do
    line = Map.get(map, row)

    if col - 1 < 0 do
      map |> Map.put(row, Map.put(line, col, "X"))
    else
      if Map.get(line, col - 1) == "#" do
        map
        |> Map.put(row, Map.put(line, col, "^"))
        |> move_guard(row, col, :up)
      else
        map
        |> Map.put(row, Map.put(line, col - 1, "<"))
        |> Map.put(row, Map.put(line, col, "X"))
        |> move_guard(row, col - 1, :left)
      end
    end
  end

  def sum_distinct_locations(map) do
    map
    |> Enum.reduce(0, fn {_, x}, acc ->
      Enum.reduce(x, acc, fn {_, y}, acc ->
        if y == "X" do
          acc + 1
        else
          acc
        end
      end)
    end)
  end
end

stream = File.stream!("./input.txt")

map =
  stream
  |> Enum.map(fn line ->
    String.trim(line)
    |> String.graphemes()
    |> Util.list_to_map()
  end)
  |> Util.list_to_map()

{row, col, dir} = Day6.find_guard_pos_and_direction(map)

part1 =
  Day6.Part1.move_guard(map, row, col, dir)
  |> Day6.Part1.sum_distinct_locations()

IO.puts("part 1: #{part1}")
