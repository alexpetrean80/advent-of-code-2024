defmodule Day8 do
  def sparse_map(text) do
    text
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _col} -> char != "." end)
      |> Enum.reduce(acc, fn {char, col}, acc ->
        if Map.get(acc, char) do
          Map.put(acc, char, [{row, col} | Map.get(acc, char)])
        else
          Map.put_new(acc, char, [{row, col}])
        end
      end)
    end)
  end

  def size(text) do
    rows =
      text
      |> Enum.reduce(0, fn _line, acc -> acc + 1 end)

    cols = hd(text) |> String.length()

    {rows, cols}
  end

  def get_pairs(list) do
    pairs =
      for {x, i} <- Enum.with_index(list), {y, j} <- Enum.with_index(list) do
        if i != j do
          {x, y}
        end
      end

    Enum.filter(pairs, fn p -> p != nil end)
  end
end

text = File.stream!("./input.txt") |> Enum.map(fn line -> String.trim(line) end)
map = Day8.sparse_map(text)
{rows, cols} = Day8.size(text)

part1 =
  map
  |> Enum.reduce([], fn {_k, v}, acc ->
    Day8.get_pairs(v)
    |> Enum.reduce(acc, fn {a, b}, acc ->
      {ax, ay} = a
      {bx, by} = b

      {x, y} = {2 * ax - bx, 2 * ay - by}

      if x < 0 || x > rows - 1 || y < 0 || y > cols - 1 do
        acc
      else
        [{x, y} | acc]
      end
    end)
  end)
  |> Enum.uniq()
  |> Enum.count()

IO.puts("part 1: #{part1}")
