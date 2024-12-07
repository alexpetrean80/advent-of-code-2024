defmodule Equation do
  @enforce_keys [:operands, :result]
  defstruct [:operands, :result]

  def new([a, b]) do
    res = String.trim(a) |> String.to_integer()

    ops =
      String.split(b, " ")
      |> Enum.map(fn op -> String.trim(op) |> String.to_integer() end)

    %Equation{result: res, operands: ops}
  end

  def valid(e) when is_struct(e) do
    possible_results(e.operands) |> Enum.count(fn pr -> pr == e.result end) > 0
  end

  defp concat(a, b) do
    String.to_integer(Integer.to_string(a) <> Integer.to_string(b))
  end

  defp possible_results([a, b]) when is_integer(a) and is_integer(b) do
    [a + b, a * b, concat(a, b)]
  end

  defp possible_results([a, b | t]) do
    [s, m, c] = possible_results([a, b])

    List.flatten([possible_results([s | t]), possible_results([m | t]), possible_results([c | t])])
  end
end

results =
  File.stream!("./input.txt")
  |> Enum.map(fn line ->
    String.split(line, ":")
    |> Enum.map(&String.trim(&1))
  end)
  |> Enum.filter(fn x -> length(x) == 2 end)
  |> Enum.map(&Equation.new(&1))
  |> Enum.filter(&Equation.valid(&1))
  |> Enum.map(fn e -> e.result end)
  |> Enum.sum()

IO.inspect(results)
