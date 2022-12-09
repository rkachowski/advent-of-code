Code.require_file("grid.exs")

defmodule Main do
  def run() do
    grid =
      %{height: height, width: width} =
      "input"
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

    require IEx
    IEx.pry()
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
end

Main.run()
