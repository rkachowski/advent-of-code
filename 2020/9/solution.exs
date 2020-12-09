defmodule Day9 do
  def parse do
    File.read("input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def solve do
    input = parse()

    result = part1(input, 25)
    IO.puts(result)

    part2(input, result)
    |> IO.puts()
  end

  def part2(numbers = [_ | t], to_find) do
    result =
      numbers
      |> Enum.reduce_while({0, []}, fn
        n, {x, l} when x + n == to_find -> {:halt, {:found, [l | [n]]}}
        n, {x, l} -> {:cont, {n + x, [l | [n]]}}
      end)

    case result do
      {:found, r} ->
        r
        |> List.flatten()
        |> (&(Enum.min(&1) + Enum.max(&1))).()

      _ ->
        part2(t, to_find)
    end
  end

  def part1(input, size) do
    {pre, list} = Enum.split(input, size)

    Enum.reduce_while(list, pre, fn n, pre = [_ | tpre] ->
      if not MapSet.member?(sums(pre), n) do
        {:halt, n}
      else
        {:cont, tpre ++ [n]}
      end
    end)
  end

  def sums([f | t]) do
    MapSet.union(MapSet.new(Enum.map(t, &(&1 + f))), sums(t))
  end

  def sums([]), do: MapSet.new([])
end

Day9.solve()
