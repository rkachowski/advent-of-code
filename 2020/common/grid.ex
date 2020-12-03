defmodule Grid do
  defstruct cells: [], width: 0, height: 0, repeat_x: false, repeat_y: false, sep: ""

  def new(width, height, init, repeat_x, repeat_y) do
    cells =
      0..(height - 1)
      |> Enum.reduce(%{}, fn y, map ->
        v =
          Enum.reduce(0..(width - 1), %{}, fn x, acc ->
            Map.put(acc, x, init)
          end)

        Map.put(map, y, v)
      end)

    %Grid{width: width, height: height, repeat_x: repeat_x, repeat_y: repeat_y, cells: cells}
  end

  #assume cells is 2d map of coords
  def new(cells, repeat_x \\ false, repeat_y \\ false) do
    height = length(Map.values(cells))
    width = length(Map.values(cells[0]))

    %Grid{width: width, height: height, repeat_x: repeat_x, repeat_y: repeat_y, cells: cells}
  end

  defp normalise(grid = %Grid{repeat_x: rx, width: w}, x, y) when rx == true and x >= w, do: normalise(grid, rem(x, w), y )
  defp normalise(grid = %Grid{repeat_x: rx, width: w}, x, y) when rx == true and x < 0, do: normalise(grid,rem(x, w) + w, y)
  defp normalise(grid = %Grid{repeat_y: ry, height: h}, x, y) when ry == true and y < 0, do: normalise(grid, x, rem(y, h) + h )
  defp normalise(grid = %Grid{repeat_y: ry, height: h}, x, y) when ry == true and y >= h, do: normalise(grid, x, rem(y, h))
  defp normalise(_, x, y), do: { x, y}

  def set(grid, x, y, val) do
    {x, y} = normalise(grid, x, y)
    put_in(grid.cells[y][x], val)
  end

  def get(grid, x, y) do
    {x, y} = normalise(grid, x, y)
    grid.cells[y][x]
  end

  def print(grid = %Grid{}) do
    Enum.each(grid.cells |> Map.values(), &(Map.values(&1) |> Enum.join(grid.sep) |> IO.puts()))
  end

  def line_to_row l do
    l 
    |> Enum.with_index 
    |> Enum.reduce( %{}, fn {v, i}, acc -> Map.put_new(acc, i, v) end)
  end
end
