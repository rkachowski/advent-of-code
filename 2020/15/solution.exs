defmodule Day15 do
  def parse(input \\ "6,13,1,15,2,0") do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solve do
    input = parse()

    IO.puts elf_game(input, 2020)
    IO.puts elf_game(input, 30000000)
  end

  def elf_game(input, target) do
    {last, input} = List.pop_at(input,-1)
    map = for {n,i} <- Enum.with_index(input), into: %{}, do: {n, i + 1}

    elf_game(map, last, length(input) + 2, target + 1)
  end

  def elf_game(_, last, turn, target) when turn == target, do: last

  def elf_game(map, last, turn, target) do
    next_number = case map[last] do
      nil -> 0
      n -> turn - 1 - n
    end

    elf_game(Map.put(map, last, turn - 1), next_number, turn + 1, target)
  end
end

Day15.solve
