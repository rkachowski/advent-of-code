defmodule Day5 do
  def parse do
    File.read("input")
    |> elem(1)
    |> String.split("\n", trim: true)
  end

  def solve do
    input = parse()

    seats =
      input
      |> Enum.map(&seat/1)

    part1 =
      seats
      |> Enum.map(fn {row, column} -> row * 8 + column end)
      |> Enum.max()

    IO.puts(part1)

    {row, taken} =
      seats
      |> Enum.reduce(%{}, fn {row, column}, acc ->
        Map.put(acc, row, [column | acc[row] || []])
      end)
      |> Map.new(fn {k, v} -> {k, Enum.sort(v)} end)
      |> Enum.find(fn {_, v} -> length(v) == 7 end)

    [column] = (0..7 |> Enum.to_list()) -- taken

    IO.puts(row * 8 + column)
  end

  def seat(input) do
    {row, column} = input |> String.graphemes() |> Enum.split(7)
    {seat(row, 0..127 |> Enum.to_list()), seat(column, 0..7 |> Enum.to_list())}
  end

  def seat([dir | t], r) when dir == "F" or dir == "L",
    do: seat(t, Enum.split(r, div(length(r), 2)) |> elem(0))

  def seat([_ | t], r), do: seat(t, Enum.split(r, div(length(r), 2)) |> elem(1))
  def seat([], [h | _]), do: h
end

Day5.solve()
