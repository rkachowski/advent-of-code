require IEx

defmodule Day23 do
  def parse(input \\ "input") do
    case input do
      "input" -> "925176834"
      "test" -> "389125467"
    end
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
  end

  def solve do
    input = parse()

    part1(input)

    part2(input)
  end

  def part1(input) do
    1..100
    |> Enum.reduce({0, input}, fn _, {i,l} -> move(l,i) end)
    |> elem(1)
    |> order
    |> IO.puts
  end

  def part2(input) do
    input = input ++ Enum.to_list(10..1000000)

    1..10000000
    |> Enum.reduce({0, input}, fn t, {i,l} ->
      IO.puts t
      move(l,i)
    end)
    |> elem(1)
    |> find_stars
    |> IO.puts
  end

  def find_stars l do
    IEx.pry
    one_index = Enum.find_index(l, &(&1 == 1))
    [Enum.at(l,one_index + 1),Enum.at(l,one_index + 2)]
  end
  def order(l) do
    one_index = Enum.find_index(l, &(&1 == 1))
    {h, [_ |t]} = Enum.split(l, one_index)
    Enum.join(t ++ h)
  end

  def move(l, i) when i == length(l), do: move(l, 0)

  def move(l, i) do
    current = Enum.at(l, i)
    {l, taken} = take_3(l, i)

    destination = find_destination(current - 1, l)

    destination_index = Enum.find_index(l, &(&1 == destination))

    {h,t} = Enum.split(l,destination_index + 1)
    result = h ++ taken ++ t

    {Enum.find_index(result, &(&1 == current)) + 1, result}
  end

  def take_3(l, i) when i < length(l) - 3 do
    {h, t} = Enum.split(l, i + 1)
    {take, t} = Enum.split(t, 3)
    {h ++ t, take}
  end

  def take_3(l = [h| t], i) when i == length(l) - 3 do
    {e, t} = Enum.split(t, 6)
    {e, t ++ [h]}
  end

  def take_3(l = [h | [n | t]], i) when i == length(l) - 2 do
    {e, t} = List.pop_at(t, -1)
    {t, [e,h,n]}
  end

  def find_destination(0, add_into), do: Enum.max(add_into)

  def find_destination(current, add_into) do
    if Enum.member?(add_into, current), do: current, else: find_destination(current - 1, add_into)
  end
end
