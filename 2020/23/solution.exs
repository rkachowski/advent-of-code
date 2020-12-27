require IEx

defmodule Day23 do
  def parse(input \\ "input") do
    case input do
      "input" -> "925176834"
      "test" -> "389125467"
    end
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def solve do
    input = parse()

    input |> part1
    input |> part2
  end

  def ring_map(list) do
    last = List.last(list)
    Enum.reduce(list, {%{}, last}, fn i, {m, l} -> {Map.put(m, l, i), i} end) |> elem(0)
  end

  def output(map) do
    2..8
    |> Enum.reduce({[map[1]], map[1]}, fn _, {l, i} -> {[map[i] | l], map[i]} end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end

  def take(map, current) do
    a = map[current]
    b = map[a]
    c = map[b]

    {Map.put(map, current, map[c]), [a, b, c]}
  end

  def put(map, [h, _, t], destination) do
    c = map[destination]

    map
    |> Map.put(destination, h)
    |> Map.put(t, c)
  end

  def part1(input) do
    current = hd(input)
    m = ring_map(input)
    max = Enum.max(input)

    1..100
    |> Enum.reduce({m, current}, fn _, {map, current} -> step(map, current, max) end)
    |> elem(0)
    |> output
    |> IO.puts()
  end

  def part2(input) do
    c = hd(input)

    m = ring_map(input ++ Enum.to_list(10..1_000_000))
    max = m |> Map.values() |> Enum.max()

    m =
      1..10_000000
      |> Enum.reduce({m, c}, fn _, {map, current} -> step(map, current, max) end)
      |> elem(0)

    r = m[1]
    r2 = m[r]
    IO.puts(r * r2)
  end

  def step(map, current, max) do
    {map, to_take} = take(map, current)
    d = find_destination(current - 1, to_take, max)
    {put(map, to_take, d), map[current]}
  end

  def find_destination(0, to_take, max), do: find_destination(max, to_take, max)

  def find_destination(current, to_take, max) do
    if Enum.member?(to_take, current),
      do: find_destination(current - 1, to_take, max),
      else: current
  end
end

Day23.solve()
