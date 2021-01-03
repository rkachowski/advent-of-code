require IEx
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

  def neighbors(grid, x, y), do: neighbors(grid, x,y, &( get(&1,&2,&3) ))
  def neighbors(grid, x, y, :not_self) do
    iter = fn grid, i,j ->
      if i == x and j == y, do: nil, else: Grid.get(grid, i,j)
    end

    neighbors(grid, x,y, iter)
  end

  def neighbors(grid, x, y, func) do
    for i <- ( x-1..x+1 |> Enum.to_list), j <- (y-1..y+1 |> Enum.to_list), do:
      func.(grid, i,j)
  end

  def print(grid = %Grid{}) do
    Enum.each(values(grid), &( &1 |> Enum.join(grid.sep) |> IO.puts()))
  end

  def line_to_row l do
    l
    |> Enum.with_index
    |> Enum.reduce( %{}, fn {v, i}, acc -> Map.put_new(acc, i, v) end)
  end

  def from_char_lists charlists do
    charlists
    |> Enum.map(&Grid.line_to_row/1)
    |> Grid.line_to_row
    |> Grid.new
  end

  def from_str str do
    str
    |> Enum.map(&String.graphemes/1)
    |> from_char_lists
  end

  def map grid, func do
    Enum.reduce(0..grid.height-1, %{}, fn y, acc ->
      Map.put(acc, y, Enum.reduce(0..grid.width-1, %{}, fn x, acc ->
        Map.put(acc, x,func.(grid,x,y))
      end))
    end)
    |> Grid.new
  end

  def values grid do
    Enum.reduce(0..grid.height-1, [], fn y, acc ->
      row = Enum.reduce(0..grid.width-1, [], fn x, acc ->
        [Grid.get(grid, x, y) | acc]
      end) |> Enum.reverse

      [row | acc]
    end) |> Enum.reverse
  end

  def rotate grid do
    columns = grid
    |> values
    |> List.flatten
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {c, i}, map ->
      index = grid.width - rem(i, grid.width)
      Map.put(map, index, [c | Map.get(map, index,[])])
    end)

    {min,max} = Enum.min_max(Map.keys(columns))

    Enum.map(min..max, &(columns[&1]))
    |> Enum.map(&Enum.reverse/1)
    |> from_char_lists
  end

  def flip grid do
    grid
    |> values
    |> Enum.map( &(&1 |> Enum.reverse))
    |> from_char_lists
  end

  def remove_borders grid do
    grid
    |> values
    |> Enum.slice(1, grid.height - 2 )
    |> Enum.map(&(&1 |> Enum.slice(1..(grid.width-2))))
    |> from_char_lists()
  end
end
