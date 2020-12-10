defmodule Day10 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.to_integer(&1)))
    |> Enum.sort
  end

  def solve do
    input = parse("test")

    {_, map} = find_adaptors(input, 0, %{1=> 0, 2=> 0, 3=>0})
    IO.puts map[1] * map[3]

    result = find_permutations input, 1
    IO.puts result
  end

  def find_permutations([ _ | []], sum), do: sum

  def find_permutations [h | tail], sum do
    permutes = tail
    |> Enum.take(3)
    |> Enum.map(fn
      n when n == h+1 or n == h+3 -> 1
      _ -> 0
    end)
    |> Enum.sum

    find_permutations tail, permutes * sum
  end

  def find_adaptors([], current, differences), do:
    {current + 3, %{differences | 3 => differences[3] + 1 }}

  def find_adaptors([h | t], current, differences), do:
    find_adaptors t, h, %{differences | h - current => differences[h - current] + 1 }
end

Day10.solve
