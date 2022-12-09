defmodule Grid do
  defstruct cells: %{}, width: nil, height: nil

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

    %Grid{cells: cells, width: width, height: height}
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

  def at(grid = %Grid{}, position = {x, y}), do: Map.get(grid.cells, position)

  def print(grid = %Grid{cells: cells, width: width, height: height}) do
    for y <- 0..height do
      for x <- 0..width do
        IO.write(:stdio, cells[{x, y}])
      end

      IO.write(:stdio, "\n")
    end

    :ok
  end
end
