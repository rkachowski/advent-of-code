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

    part2(input)
    |> IO.puts
  end

  def part1(input, count \\ 0) do
    m = Grid.map(input, &cell_map1/3)
    case Grid.values(m) |> Enum.count(&(&1 == "#")) do
      ^count -> count
      n -> part1(m, n)
    end
  end

  def part2(input, count \\0 ) do
    m = Grid.map(input, &cell_map2/3)

    case Grid.values(m) |> Enum.count(&(&1 == "#")) do
      ^count -> count
      n -> part2(m, n)
    end
  end

  def cell_map1 grid, x, y do
    contents = Grid.get(grid,x,y)
    occupied = Grid.neighbors(grid,x,y,:not_self) |> Enum.count(&(&1 == "#"))

    case contents do
      "L" when occupied == 0 -> "#"
      "#" when occupied >= 4 -> "L"
      _ -> contents
    end
  end


  def cell_map2 grid, x, y do
    contents = Grid.get(grid,x,y)
    occupied = iters(x,y)
    |> Enum.map(&(iterate_in_direction(&1, grid)))
    |> Enum.count(&(&1 == "#"))

    case contents do
      "L" when occupied == 0 -> "#"
      "#" when occupied >= 5 -> "L"
      _ -> contents
    end
  end

  def iters x,y do
    for x <- [-1,0,1], y <- [-1,0,1] do
      case {x,y} do
        {0,0} -> nil
        {_, _} -> {x,y}
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&(iterable_stream({x,y}, &1)))
  end

  def iterable_stream {x,y}, {dx,dy} do
    Stream.resource(
      fn -> {x,y} end,
      fn {i,j} -> {[{i + dx, j + dy}], {i + dx, j + dy}} end,
      fn x -> x end
    )
  end

  def iterate_in_direction dir, grid do
    Enum.reduce_while(dir, nil, fn {x,y}, _ ->
      case Grid.get(grid, x,y) do
        val when val in ["#","L"] -> {:halt, val}
        nil -> {:halt, nil}
        _ -> {:cont, nil}
      end
    end)
  end
end

Day11.solve
