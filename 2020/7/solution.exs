defmodule Day7 do

  def parse do
    bag_info = File.read("input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_bag_info/1 )

    for {bag, contents} <- bag_info, into: %{}, do: {bag, contents}
  end

  def extract_bag_info rule do
    [bag] = Regex.run(~r/^\w+\s\w+/, rule)

    contents = Regex.scan(~r/((?:\d)\s\w+\s\w+)|(no other bags)/, rule)
    |> Enum.map(&(Enum.at(&1,0)))
    |> Enum.map(fn c ->
      case c do
      "no other bags" -> { 0 }
      _ ->
        [_, count, color] = Regex.run(~r/(\d+)\s(\w+\s\w+)/, c)
        {String.to_integer(count), color}
      end
    end)

    {bag, contents}
  end

  def solve do
    bags = parse()

    get_bags(["shiny gold"], bags)
    |> List.flatten
    |> MapSet.new
    |> Enum.count
    |> IO.puts
  end

  def get_bags [], map do
    []
  end

  def get_bags [colors | tail], map do
    c = containers(colors, map)
    [c | [get_bags(c,map) | get_bags(tail, map)]]
  end

  def containers color, bags do
    Enum.filter(bags, fn {_, c} ->
      Enum.any?(c ,fn
        {0} -> false
        {_, contentcolor} -> contentcolor == color end)
    end)
    |> Enum.map(&( &1 |> elem(0)))
  end
end

Day7.solve
