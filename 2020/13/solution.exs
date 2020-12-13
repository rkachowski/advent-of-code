defmodule Day13 do
  def parse(input \\ "input") do
    [timestamp, numbers] = File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)

    {String.to_integer(timestamp), String.split(numbers, ",", trim: true)}
  end

  def solve do
    input = parse()

    IO.puts part1(input)
  end

  def part1({timestamp, nums}) do
    buses = nums
    |> Enum.reject(&( &1 == "x"))
    |> Enum.map(&(String.to_integer(&1)))

    {time, bus} = Enum.map(buses, &( { &1 * trunc(ceil(timestamp / &1 )) - timestamp, &1} ))
    |> Enum.min_by(&(elem(&1,0)))

    time * bus
  end
end

Day13.solve
