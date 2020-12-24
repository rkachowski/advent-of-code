require IEx

defmodule Day24 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def solve do
    input = parse()

    black_tiles = input |> part1
    
    black_tiles |> Enum.count() |> IO.puts()
    black_tiles |> MapSet.new() |> part2 |> Enum.count() |> IO.puts()
  end

  def part1(input) do
    input
    |> Enum.map(&move({&1, {0, 0, 0}}))
    |> Enum.reduce(%{}, &count_map(&2, &1))
    |> Enum.reduce([], fn {coord, count}, l ->
      if rem(count, 2) == 1, do: [coord | l], else: l
    end)
  end

  def move({["e" | t], {x, y, z}}), do: move({t, {x + 1, y - 1, z}})
  def move({["w" | t], {x, y, z}}), do: move({t, {x - 1, y + 1, z}})
  def move({["n" | ["e" | t]], {x, y, z}}), do: move({t, {x + 1, y, z - 1}})
  def move({["s" | ["w" | t]], {x, y, z}}), do: move({t, {x - 1, y, z + 1}})
  def move({["n" | ["w" | t]], {x, y, z}}), do: move({t, {x, y + 1, z - 1}})
  def move({["s" | ["e" | t]], {x, y, z}}), do: move({t, {x, y - 1, z + 1}})
  def move({[], coord}), do: coord

  def part2(tiles) do
    1..100
    |> Enum.reduce(tiles, fn _, tiles -> update_tiles(tiles) end)
  end

  def update_tiles(tiles) do
    tiles
    |> Enum.to_list()
    |> Enum.reduce([], &(neighbors(&1) ++ &2))
    |> Enum.reduce(%{}, &count_map(&2, &1))
    |> Enum.reduce([], fn {coord, count}, l ->
      case count do
        1 -> if MapSet.member?(tiles, coord), do: [coord | l], else: l
        2 -> [coord | l]
        _ -> l
      end
    end)
    |> MapSet.new()
  end

  def neighbors({x, y, z}) do
    [
      {x + 1, y - 1, z},
      {x - 1, y + 1, z},
      {x + 1, y, z - 1},
      {x - 1, y, z + 1},
      {x, y + 1, z - 1},
      {x, y - 1, z + 1}
    ]
  end

  def count_map(map, element) do
    Map.put(map, element, Map.get(map, element, 0) + 1)
  end
end
