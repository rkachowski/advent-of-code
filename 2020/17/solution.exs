defmodule Day17 do

  def parse(input \\ "input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&( String.graphemes(&1) |> Enum.with_index ))
    |> Enum.with_index
    |> Enum.reduce([], fn {row, y}, acc ->
      acc ++ Enum.reduce(row, [], fn
        {".", _}, acc -> acc
        {"#", x}, acc -> [{x,y,0} | acc]
      end)
    end)
    |> MapSet.new
  end

    def solve do
      input = parse("input")

      Enum.reduce(0..5, input, fn _,grid -> conway(grid, &neighbors3d/1) end)
      |> MapSet.size
      |> IO.puts

      part2input = Enum.map(input, fn {x,y,z} -> {x,y,z,0} end) |> MapSet.new

      Enum.reduce(0..5, part2input, fn _,grid -> conway(grid, &neighbors4d/1) end)
      |> MapSet.size
      |> IO.puts
    end

    def conway grid, neighbor_func do
      grid
      |> Enum.reduce(%{},fn coord, acc ->
        Enum.reduce(neighbor_func.(coord), acc, fn coord, map -> updateneighbormap(map, coord) end)
      end)
      |> Enum.reduce(MapSet.new([]), fn
        {k,2}, map ->
          if MapSet.member?(grid, k), do: MapSet.put(map, k), else: map
        {k,3}, map ->
          MapSet.put(map, k)
        _, map -> map
      end)
    end

    def updateneighbormap(map, coord) do
      case map[coord] do
        nil -> Map.put(map, coord, 1)
        n -> Map.put(map, coord, n+1)
      end
    end

    def neighbors3d(k = {x, y, z}) do
      r = for i <- x-1..x+1,
        j <- y-1..y+1,
        k <- z-1..z+1,
        into: MapSet.new,
        do: {i,j,k}

      MapSet.delete(r, k)
    end

    def neighbors4d(k = {x, y, z, w}) do
      r = for i <- x-1..x+1,
        j <- y-1..y+1,
        k <- z-1..z+1,
        l <- w-1..w+1,
        into: MapSet.new,
        do: {i,j,k,l}

      MapSet.delete(r, k)
    end

  end

  Day17.solve
