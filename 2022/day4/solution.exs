defmodule Main do
  def run do
    input = parse_input()

    input |> part1() |> IO.inspect()
    input |> part2() |> IO.inspect()
  end

  def part1(input) do
    input
    |> Enum.map(fn ranges ->
      [first, second] = ranges |> Enum.sort_by(&MapSet.size/1)

      MapSet.subset?(first, second)
    end)
    |> Enum.reduce(0, fn
      true, acc -> acc + 1
      false, acc -> acc
    end)
  end

  def part2(input) do
    input
    |> Enum.map(fn [first, second] ->
      MapSet.intersection(first, second) |> MapSet.size()
    end)
    |> Enum.reduce(0, fn
      n, acc when n > 0 -> acc + 1
      _, acc -> acc
    end)
  end

  def parse_input(file \\ "input") do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(fn range ->
        [first, second] =
          range
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)

        Range.new(first, second) |> Enum.to_list() |> MapSet.new()
      end)
    end)
  end
end

Main.run()
