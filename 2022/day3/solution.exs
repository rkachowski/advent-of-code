defmodule Main do
  def run() do
    input = parse_input()

    input |> part1() |> IO.puts()

    input |> part2() |> IO.puts()
  end

  def parse_input(file \\ "input") do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  @char_range ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
  def priority(ch), do: Enum.find_index(@char_range, &(&1 == ch)) + 1

  def part1(input) do
    input
    |> Enum.map(fn backpack ->
      compartments =
        backpack
        |> Enum.split(floor(length(backpack) / 2))
        |> Tuple.to_list()

      duplicate_letter =
        compartments
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(fn e, acc ->
          MapSet.intersection(e, acc)
        end)
        |> mapset_to_str()

      duplicate_letter |> priority()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    groups = input |> Enum.chunk_every(3)

    badges =
      groups
      |> Enum.map(fn group ->
        group
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(fn e, acc ->
          MapSet.intersection(e, acc)
        end)
        |> mapset_to_str()
      end)

    badges |> Enum.map(&priority/1) |> Enum.sum()
  end

  def mapset_to_str(set), do: set |> MapSet.to_list() |> Enum.join()
end

Main.run()
