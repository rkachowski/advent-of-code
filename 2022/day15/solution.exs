defmodule Main do
  def run(file \\ "test") do
    input = file |> parse_input()

    input |> part1(2_000_000) |> IO.puts()
  end

  def part1(coords, line) do
    distinct =
      coords
      |> Task.async_stream(&convert_to_manhattan/1, max_concurrency: 10, timeout: :infinity)
      |> Enum.reduce(fn {:ok, points}, acc ->
        MapSet.union(points, acc)
      end)

    beacons = coords |> Enum.map(fn [_, [bx, by]] -> {bx, by} end)

    beacons
    |> Enum.reduce(distinct, fn point, map ->
      MapSet.delete(map, point)
    end)
    |> Enum.filter(fn {_, y} -> y == line end)
    |> Enum.count()
  end

  def convert_to_manhattan([[x, y], [bx, by]]) do
    width = abs(x - bx)
    height = abs(y - by)

    distance = width + height

    for ny <- (y - distance)..(y + distance),
        nx <- (x - distance)..(x + distance),
        abs(x - nx) + abs(y - ny) <= distance,
        into: MapSet.new(),
        do: {nx, ny}
  end

  def parse_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/(-?\d+)/
      |> Regex.scan(line, capture: :first)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 2)
    end)
  end
end

Main.run("input")
