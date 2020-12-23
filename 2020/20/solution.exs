require IEx

defmodule Day20 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
    |> Enum.reduce(%{}, fn {n,g},map -> Map.put(map, n, g) end)
  end

  def parse_tile(str) do
    [name | data] = str |> String.split("\n", trim: true)

    name = Regex.run(~r/(\d+)/, name, result: :all_but_first) |> Enum.at(0)

    {name, Grid.from_str(data)}
  end

  def solve do
    input = parse()
    IEx.pry
  end

  def borders grid do
    top = for x <- 0..(grid.width-1), do: Grid.get grid, x, 0
    bottom = for x <- 0..(grid.width-1), do: Grid.get grid, x, grid.height-1
    left = for y <- 0..(grid.height-1), do: Grid.get grid, 0, y
    right = for y <- 0..(grid.height-1), do: Grid.get grid, grid.width-1, y

    {top, bottom, left, right}
  end

end

Day20.solve
