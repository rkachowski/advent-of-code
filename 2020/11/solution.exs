defmodule Day11 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Grid.from_char_lists
  end

  def solve do
    input = parse("input")

    part1(input)
    |> IO.puts
  end

  def part1(input, count \\ 0) do
    m = Grid.map(input, &output_for_cell/3)
    case Grid.values(m) |> Enum.count(&(&1 == "#")) do
      ^count -> count
      n -> part1(m, n)
    end
  end

  def output_for_cell grid, x, y do
    contents = Grid.get(grid,x,y)
    occupied = Grid.neighbors(grid,x,y,:not_self) |> Enum.count(&(&1 == "#"))

    case contents do
      "L" when occupied == 0 -> "#"
      "#" when occupied >= 4 -> "L"
      _ -> contents
    end
  end
end

Day11.solve
