defmodule Day6 do
  def parse do
    File.read("input")
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s/, trim: true))
  end

  def solve do
    groups = parse()

    unique_answers_in_group =
      groups
      |> Enum.map(fn group ->
        Enum.map(group, &String.graphemes/1) |> List.flatten() |> MapSet.new()
      end)

    unique_answers_in_group
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
    |> IO.puts()

    groups =
      groups
      |> Enum.map(&Enum.map(&1, fn g -> String.graphemes(g) |> MapSet.new() end))

    unique_answers_in_group
      |> Enum.zip(groups)
      |> Enum.map(fn {map, groups} ->
        Enum.count(map, fn c -> Enum.all?(groups, &MapSet.member?(&1, c)) end)
      end)
      |> Enum.sum
      |> IO.puts

  end
end

Day6.solve()
