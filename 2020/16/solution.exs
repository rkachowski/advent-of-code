defmodule Day16 do
  def parse(input \\ "input") do
    [rules, myticket, nearby] = File.read(input)
    |> elem(1)
    |> String.split("\n\n")

    myticket = myticket
    |> String.split("\n", trim: true)
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    nearby = nearby
    |> String.replace_leading("nearby tickets:\n","")
    |> String.split("\n", trim: true)
    |> Enum.map( &( String.split(&1, ",",trim: true) |> Enum.map( fn s -> String.to_integer(s) end) ))

    rules = rules
    |> String.split("\n", trim: true)
    |> Enum.map( &(String.split(&1, ": ", trim: true)))
    |> Enum.reduce(%{}, fn [name, range], acc ->
      Map.put(acc, name, parse_range(range))
    end)

    {rules, myticket, nearby}
  end

  def parse_range str do
    str
    |> String.split(" or ", trim: true)
    |> Enum.map( fn rangestr ->
      [f, l] = String.split(rangestr,"-",trim: true) |> Enum.map(&String.to_integer/1)
      Range.new(f,l)
    end)
  end

  def solve do
    input = parse()

    IO.puts part1(input)
    IO.puts part2(input)
  end

  def part1 {rules, _, nearby} do
    ranges = rules
    |> Map.values
    |> List.flatten

    Enum.reduce(nearby, [], fn ticket, invalids ->
      invalids ++ Enum.filter(ticket, &(Enum.all?(ranges, fn r -> not Enum.member?(r, &1) end)))
    end)
    |> Enum.sum
  end

  def part2 {rules, myticket, nearby} do
    value_map = nearby
    |> valid_tickets(rules)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.reduce(%{}, fn t, map ->
      Enum.reduce(t,map,  fn {v, i}, map ->
          case map[i] do
            nil -> Map.put(map, i, [v])
            _ -> Map.put(map, i, [v | map[i]])
          end
      end)
    end)

    rule_map = rules
    |> find_possible_ticket_indices(value_map)
    |> reduce_correct_indices

    rule_map
    |> Enum.filter(fn {n,_} -> String.contains?(n, "departure") end)
    |> Enum.map(fn {_, i} -> Enum.at(myticket, i) end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def valid_tickets(tickets, rules) do
    ranges = rules
    |> Map.values
    |> List.flatten

    Enum.reject(tickets, fn ticket ->
      Enum.any?(ticket, &(Enum.all?(ranges, fn r -> not Enum.member?(r, &1) end)))
    end)
  end

  def find_possible_ticket_indices(input, value_map) do
    input
    |> Enum.reduce(%{}, fn {name, [r1, r2]}, map ->
      possible_indexes = Enum.filter(value_map, fn {_, vals} ->
        Enum.all?(vals, &( Enum.member?(r1, &1) or Enum.member?(r2, &1) ))
      end)
      |> Enum.map(&(elem(&1,0)))

      Map.put(map, name, possible_indexes)
    end)
  end

  def reduce_correct_indices(input) do
    ordered = input
    |> Enum.to_list
    |> Enum.sort(&(length(elem(&1,1)) <= length(elem(&2,1))))

    {map, _ } = Enum.reduce(ordered, {%{}, MapSet.new([])}, fn {name, indexes},{map,taken} ->
      [i] = MapSet.difference(MapSet.new(indexes), taken) |> Enum.to_list
      {Map.put(map, name,i), MapSet.union(taken, MapSet.new(indexes))}
    end)

    map
  end
end

Day16.solve
