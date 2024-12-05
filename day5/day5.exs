defmodule Day5 do
  def read_rules(stream) do
    stream
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn pair ->
      Enum.map(pair, fn x ->
        x
        |> String.trim()
        |> String.to_integer()
      end)
    end)
    |> Enum.reduce(%{}, fn [x, y], acc ->
      if Map.get(acc, x) do
        Map.put(acc, x, [y | Map.get(acc, x)])
      else
        Map.put_new(acc, x, [y])
      end
    end)
  end

  def read_updates(stream) do
    stream
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(",")
      |> Enum.map(fn page ->
        page
        |> String.to_integer()
      end)
    end)
  end

  def update_valid?(update, rules) do
    pairs = get_pairs(update)
    Enum.all?(pairs, fn {x, y} -> check_pages_order(x, y, rules) end)
  end

  def get_middle_number(update) do
    Enum.at(update, div(length(update), 2))
  end

  def compute_result(updates) do
    updates
    |> Enum.map(&Day5.get_middle_number(&1))
    |> Enum.sum()
  end

  def check_pages_order(first, second, rules) do
    l = Map.get(rules, first)
    Enum.any?(l, fn x -> x == second end)
  end

  def get_pairs(update) do
    for {x, i} <- Enum.with_index(update), y <- Enum.slice(update, (i + 1)..-1//1) do
      {x, y}
    end
  end

  def fix_incorrect_update(update, rules) do
    if update == [] do
      []
    end

    Enum.reduce(update, [], fn page, acc ->
      other = Enum.filter(update, fn x -> x != page end)

      first? = Enum.all?(other, fn other_page -> check_pages_order(page, other_page, rules) end)

      if first? do
        [page | fix_incorrect_update(other, rules)]
      else
        acc
      end
    end)
  end
end

rules =
  File.stream!("./input/rules.txt")
  |> Day5.read_rules()

updates =
  File.stream!("./input/input.txt")
  |> Day5.read_updates()

part1 =
  Enum.filter(updates, &Day5.update_valid?(&1, rules))
  |> Day5.compute_result()

part2 =
  Enum.filter(updates, fn x -> !Day5.update_valid?(x, rules) end)
  |> Enum.map(&Day5.fix_incorrect_update(&1, rules))
  |> Day5.compute_result()

IO.puts("part 1: #{part1}")
IO.puts("part 2: #{part2}")
