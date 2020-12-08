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


  def get_bags [], _ do
    []
  end

  def get_bags [colors | tail], map do
    c = containers(colors, map)
    [c | [get_bags(c,map) | get_bags(tail, map)]] |> List.flatten
  end

  def containers color, bags do
    Enum.filter(bags, fn {_, c} ->
      Enum.any?(c ,fn
        {0} -> false
        {_, contentcolor} -> contentcolor == color end)
    end)
    |> Enum.map(&( &1 |> elem(0)))
  end

  def total_bags {0}, _ do
    0
  end


  def total_bags {num, color}, map do
    contents = map[color]
    |> Enum.reduce(0, &(total_bags(&1,map) + &2  ))

    num + (num * contents)
  end

  def total_bags color, map do
    total_bags({1, color}, map) - 1 #don't count the top level bag
  end

  def solve do
    bags = parse()

    get_bags(["shiny gold"], bags)
    |> MapSet.new
    |> Enum.count
    |> IO.puts

    total_bags("shiny gold", bags)
    |> IO.puts
  end
end

Day7.solve
