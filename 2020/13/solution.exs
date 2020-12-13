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

    IO.puts part2(input)
  end

  def part1({timestamp, nums}) do
    buses = nums
    |> Enum.reject(&( &1 == "x"))
    |> Enum.map(&(String.to_integer(&1)))

    {time, bus} = Enum.map(buses, &( { &1 * trunc(ceil(timestamp / &1 )) - timestamp, &1} ))
    |> Enum.min_by(&(elem(&1,0)))

    time * bus
  end

  def part2({_,buses}) do
    input = buses
    |> Enum.with_index
    |> Enum.reject(&(elem(&1,0) == "x"))
    |> Enum.map(&( {String.to_integer(elem(&1,0)), elem(&1,1)}  ))

    [{bus, _} | tail] = input

    {_, t} = Enum.reduce(tail,{bus, 0}, fn {bus, i},{inc,  t} ->
      crm t, inc, i, bus
    end)

    IO.puts t
  end

  def crm(t, inc, offset, bus) when rem(t + offset, bus) == 0, do: {inc * bus, t}
  def crm(t, inc, offset, bus), do: crm t + inc, inc, offset, bus
end

Day13.solve
