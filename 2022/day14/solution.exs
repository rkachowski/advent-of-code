Code.require_file("../common/grid.exs")

defmodule Main do
  def run() do
    input = parse_input()

    part1 = input |> get_rocks()

    map = part1 |> Enum.into(%{}, &{&1, "#"}) |> Grid.import()

    run_sand(map)
  end

  def run_sand(map) do
    new_sand = {500, 0}

    final = sand_step(map, new_sand)
    dbg()
  end

  def sand_step(grid = %{cells: map}, {x, y} = position) do
    dbg()

    next =
      cond do
        map[{x, y + 1}] == "." -> {x, y + 1}
        map[{x - 1, y + 1}] == "." -> {x - 1, y + 1}
        map[{x + 1, y + 1}] == "." -> {x + 1, y + 1}
        !Grid.inside(grid, position) -> :out
        true -> :done
      end

    case next do
      :done -> position
      :out -> :out
      n -> sand_step(map, next)
    end
  end

  def get_rocks(input) do
    input
    |> Enum.flat_map(fn line ->
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.flat_map(fn [p1, p2] -> expand_points(p1, p2) end)
    end)
    |> Enum.uniq()
  end

  def parse_input(file \\ "test") do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/\d+,\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&parse_coord/1)
    end)
  end

  def parse_coord(c) do
    [x, y] =
      c
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {x, y}
  end

  def expand_points({x, y1}, {x, y2}) do
    y1..y2
    |> Enum.to_list()
    |> Enum.map(&{x, &1})
  end

  def expand_points({x1, y}, {x2, y}) do
    x1..x2
    |> Enum.to_list()
    |> Enum.map(&{&1, y})
  end
end

Main.run()
