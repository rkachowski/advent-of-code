require IEx
defmodule Day21 do

  def parse(input \\"input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      [ingredients, allergens] = String.split(str, " (contains ", trim: true)
      ingredients = ingredients |> String.split(~r/\s/, trim: true)
      allergens = allergens |> String.trim_trailing(")") |> String.split(~r/,\s/, trim: true)
      {ingredients, allergens}
    end)
  end

  def solve do
    input = parse()

    {result, possible_allergens} = part1(input)
    result |> IO.puts

    possible_allergens
    |> solve_allergens
    |> Enum.map(fn {_,v} -> Enum.at(v,0) end)
    |> Enum.join(",")
    |> IO.puts
  end

  def part1 input do
    allergens = input
    |> Enum.reduce(%{}, fn {i,a}, map ->
      Enum.reduce(a, map, &(Map.put(&2, &1, [i | Map.get(&2, &1,[])])))
    end)
    |> Enum.map(&reduce_allergens/1)

    possible = allergens
    |> Enum.reduce(MapSet.new([]), fn {_, p},possible ->
      MapSet.union(p, possible)
    end)

    result = input
    |> Enum.map(fn {l,_} -> Enum.reject(l, &(MapSet.member?(possible, &1))) end)
    |> List.flatten
    |> count_map
    |> Map.values
    |> Enum.sum

    allergen_map = allergens
    |> Enum.reduce(%{}, fn {a, p}, map -> Map.put(map, a,p) end)

    {result, allergen_map}
  end

  def solve_allergens map do
    solved = map
    |> Map.values
    |> Enum.filter(&(Enum.count(&1) == 1 ))
    |> List.flatten
    |> MapSet.new

    solve_allergens map, solved
  end

  def solve_allergens map, solved do
    {map,solved} = map
    |> Enum.reduce({%{}, solved}, fn {k,v}, {map,solved} ->
      case Enum.count(v) do
        1 ->
          {Map.put(map, k, v), MapSet.put(solved, Enum.at(v,0))}
        _ ->
          v = Enum.reject(v, &( MapSet.member?(solved, &1) ))
          {Map.put(map, k, v), solved}
      end
    end)

    if Enum.any?(map, fn {_,v} -> Enum.count(v) > 1 end) do
      solve_allergens map, solved
    else
      map
    end
  end

  def reduce_allergens {allergen, [h | t]} do
    possible = t
    |> Enum.reduce(MapSet.new(h), fn ingredients, possible ->
      MapSet.intersection(MapSet.new(ingredients), possible)
    end)

    {allergen, possible}
  end

  def sym_dif a, b do
    MapSet.difference(MapSet.union(a,b), MapSet.intersection(a,b))
  end

  def count_map list do
    list
    |> Enum.reduce(%{}, &(Map.put(&2, &1, Map.get(&2, &1,0) + 1)))
  end
end

Day21.solve
