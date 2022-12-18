defmodule Grid do
  defstruct cells: %{}, width: nil, height: nil, bounds: %{}

  def import(cells, default \\ ".") when is_map(cells) do
    bounds = cells |> Map.keys() |> bounding_box()

    width = bounds.x2 - bounds.x1
    height = bounds.y2 - bounds.y1

    empty_cells =
      for y <- bounds.y1..bounds.y2, x <- bounds.x1..bounds.x2, into: %{}, do: {{x, y}, default}

    %Grid{cells: Map.merge(empty_cells, cells), width: width, height: height, bounds: bounds}
  end

  def new(input = [hd | _]) when is_list(input) do
    width = length(hd)
    height = length(input)

    cells =
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {cell, x}, acc ->
          Map.put(acc, {x, y}, cell)
        end)
      end)

    bounds = cells |> Map.keys() |> bounding_box()

    %Grid{cells: cells, width: width, height: height, bounds: bounds}
  end

  def new(str) when is_binary(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Grid.new()
  end

  def map(grid = %{cells: cells}, func) do
    %{grid | cells: Enum.into(cells, %{}, func)}
  end

  def at(grid = %Grid{}, position), do: Map.get(grid.cells, position)

  def inside(%{bounds: %{x1: x1, y1: y1, x2: x2, y2: y2}}, {x, y})
      when x >= x1 and y >= y1 and x <= x2 and y <= y2,
      do: true

  def inside(_, _), do: false

  def print(%Grid{cells: cells, bounds: %{x1: x1, y1: y1, x2: x2, y2: y2}}, upper_layer \\ %{}) do
    for y <- y1..y2 do
      for x <- x1..x2 do
        char =
          case Map.get(upper_layer, {x, y}) do
            nil -> cells[{x, y}]
            n -> n
          end

        IO.write(:stdio, char)
      end

      IO.write(:stdio, "\n")
    end

    :ok
  end

  def every_position(%{width: width, height: height}) do
    for y <- 0..(height - 1), x <- 0..(width - 1), into: [], do: {x, y}
  end

  def bounding_box([{x, y} | points]) do
    points
    |> Enum.reduce(%{x1: x, y1: y, x2: x, y2: y}, fn {px, py}, box ->
      %{
        x1: min(px, box.x1),
        y1: min(py, box.y1),
        x2: max(px, box.x2),
        y2: max(py, box.y2)
      }
    end)
  end
end
