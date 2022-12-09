Code.require_file("grid.exs")

defmodule Main do
  def run() do
    grid =
      %{height: height} =
      "test"
      |> File.read!()
      |> Grid.new()
      |> Grid.map(fn {k, v} -> {k, String.to_integer(v)} end)

    result =
      1..(height - 1)
      |> Enum.flat_map(&visible_row(grid, &1))
      |> MapSet.new()

    require IEx
    IEx.pry()
  end

  def visible_row(grid, row) do
    0..(grid.width - 1)
    |> Enum.map(&{&1, row})
    |> visible(grid)
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

  
end

Main.run()


fn coord = {x,y}, acc when x >= 0 and y >= 0 ->
  {:cont, [ func.(coord) | acc]}
