defmodule Report do
  def safe?(report) do
    (is_ascending(report) || is_descending(report)) && check_levels(report)
  end

  defp is_ascending(report) do
    report == Enum.sort(report)
  end

  defp is_descending(report) do
    report == report |> Enum.sort() |> Enum.reverse()
  end

  defp check_levels(report) do
    case report do
      [a, b] -> abs(a - b) in 1..3
      [a, b | t] -> check_levels([a, b]) && check_levels([b | t])
    end
  end

  defp generate_sublists(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {_, i} -> List.delete_at(list, i) end)
  end

  def problem_dampen_safe?(report) do
    if safe?(report) do
      true
    else
      report
      |> generate_sublists()
      |> Enum.any?(&safe?(&1))
    end
  end
end

stream = File.stream!("./input.txt")

reports =
  stream
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(
    &(&1
      |> Enum.map(fn x ->
        x
        |> String.trim()
        |> String.to_integer()
      end))
  )

part1_res =
  reports
  |> Enum.filter(&Report.safe?(&1))
  |> Enum.count()

part2_res =
  reports
  |> Enum.filter(&Report.problem_dampen_safe?(&1))
  |> Enum.count()

IO.puts("part 1: #{part1_res}")
IO.puts("part 2: #{part2_res}")
