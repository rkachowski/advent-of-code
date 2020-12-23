defmodule Day22 do
  def parse(input \\ "input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn g ->
      [_ | t] = g |> String.split("\n", trim: true)
      t |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve do
    [p1, p2] = parse()

    part1(p1, p2) |> IO.puts()
    part2(p1, p2) |> elem(1) |> IO.puts()
  end

  def part1(win, []), do: score(win)
  def part1([], win), do: score(win)

  def part1([h1 | p1], [h2 | p2]) do
    cond do
      h1 < h2 -> part1(p1, p2 ++ [h2, h1])
      h1 > h2 -> part1(p1 ++ [h1, h2], p2)
      true -> nil
    end
  end

  def part2(p1, p2) do
    part2(p1, p2, MapSet.new([]))
  end

  def part2(p1, [], _), do: {:p1, score(p1)}
  def part2([], p2, _), do: {:p2, score(p2)}

  def part2(p1 = [h1 | t1], p2 = [h2 | t2], already_seen) do
    {winner, _} =
      cond do
        MapSet.member?(already_seen, {p1, p2}) ->
          {:p1_win, nil}

        length(t1) >= h1 and length(t2) >= h2 ->
          part2(Enum.take(t1, h1), Enum.take(t2, h2), MapSet.new([]))

        h1 < h2 ->
          {:p2, nil}

        h1 > h2 ->
          {:p1, nil}

        true ->
          {"u done fucked up", "how did this happen"}
      end

    case winner do
      :p1_win -> {:p1, score(p1)}
      :p2 -> part2(t1, t2 ++ [h2, h1], MapSet.put(already_seen, {p1, p2}))
      :p1 -> part2(t1 ++ [h1, h2], t2, MapSet.put(already_seen, {p1, p2}))
    end
  end

  def score(l) do
    l
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {s, i}, tot -> tot + s * (i + 1) end)
  end
end

Day22.solve()
