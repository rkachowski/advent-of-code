Code.require_file("grid.exs")

defmodule Main do
  def run(file \\ "input") do
    grid =
      %{height: height, width: width} =
      file
      |> File.read!()
      |> Grid.new()
      |> Grid.map(fn {k, v} -> {k, String.to_integer(v)} end)

    rows =
      1..(height - 1)
      |> Enum.flat_map(&visible_row(grid, &1))
      |> MapSet.new()

    columns =
      1..(width - 1)
      |> Enum.flat_map(&visible_column(grid, &1))
      |> MapSet.new()

    result =
      MapSet.union(rows, columns)
      |> MapSet.union(edge_coords(grid))

    IO.puts(MapSet.size(result))

    result =
      grid
      |> Grid.every_position()
      |> Task.async_stream(
        fn position ->
          up(grid, position) * down(grid, position) * left(grid, position) * right(grid, position)
        end,
        max_concurrency: 500
      )
      |> Enum.map(fn {:ok, result} -> result end)
      |> Enum.max()

    IO.puts(result)
  end

  def visible_row(grid = %{height: h, width: w}, row) do
    left =
      [{0, row}]
      |> gen_coord(fn {x, y} -> {x + 1, y} end, {w, h})
      |> visible(grid)
      |> MapSet.new()

    right =
      [{w - 1, row}]
      |> gen_coord(fn {x, y} -> {x - 1, y} end, {w, h})
      |> visible(grid)
      |> MapSet.new()

    MapSet.union(left, right)
  end

  def visible_column(grid = %{height: h, width: w}, column) do
    top =
      [{column, 0}]
      |> gen_coord(fn {x, y} -> {x, y + 1} end, {w, h})
      |> visible(grid)
      |> MapSet.new()

    bottom =
      [{column, h - 1}]
      |> gen_coord(fn {x, y} -> {x, y - 1} end, {w, h})
      |> visible(grid)
      |> MapSet.new()

    MapSet.union(top, bottom)
  end

  def visible(coords = [first | _], grid) do
    first_tree = Grid.at(grid, first)

    {_, visible_cells} =
      coords
      |> Enum.reduce({first_tree, [first]}, fn coord, acc = {max, visible} ->
        case Grid.at(grid, coord) do
          n when n > max -> {n, [coord | visible]}
          _ -> acc
        end
      end)

    visible_cells
  end

  def gen_coord(coords = [hd = {x, y} | _], func, {max_x, max_y} = max)
      when x >= 0 and y >= 0 and x < max_x and y < max_y do
    gen_coord([func.(hd) | coords], func, max)
  end

  def gen_coord([_ | coords], _func, _max), do: Enum.reverse(coords)

  def edge_coords(%{width: w, height: h}) do
    top_and_bottom =
      for x <- 0..(w - 1), reduce: [] do
        acc ->
          [{x, 0}, {x, h - 1}] ++ acc
      end

    left_and_right =
      for y <- 0..(h - 1), reduce: [] do
        acc ->
          [{0, y}, {w - 1, y}] ++ acc
      end

    MapSet.new(top_and_bottom ++ left_and_right)
  end

  def up(grid, position), do: visible_count(grid, position, {0, -1})
  def down(grid, position), do: visible_count(grid, position, {0, 1})
  def left(grid, position), do: visible_count(grid, position, {-1, 0})
  def right(grid, position), do: visible_count(grid, position, {1, 0})

  def visible_count(grid, position = {x, y}, {dx, dy}) do
    start_cell = Grid.at(grid, position)

    {x + dx, y + dy}
    |> Stream.iterate(fn {x, y} ->
      {x + dx, y + dy}
    end)
    |> Enum.reduce_while(0, fn next_point, vis ->
      cond do
        !Grid.inside(grid, next_point) -> {:halt, vis}
        Grid.at(grid, next_point) >= start_cell -> {:halt, vis + 1}
        true -> {:cont, vis + 1}
      end
    end)
  end
end

Main.run()
