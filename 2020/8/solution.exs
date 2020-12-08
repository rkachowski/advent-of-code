defmodule Day8 do
  def parse do
    File.read("input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/(\w+)\s((?:\+|-)\d+)/, &1))
  end

  def solve do
    input = parse()

    {:loop, {_, acc, _}} = solve1(input, {0, 0, MapSet.new()})
    IO.puts(acc)

    modifiable =
      input
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {[_, "nop", _], i}, acc -> [i | acc]
        {[_, "jmp", _], i}, acc -> [i | acc]
        {_, _}, acc -> acc
      end)

    brute_force(modifiable, input)
    |> elem(1)
    |> IO.puts()
  end

  def solve1(input, {index, acc, seen}) when index >= length(input),
    do: {:end, {index, acc, seen}}

  def solve1(input, {index, acc, seen}) do
    inst = Enum.at(input, index)

    cond do
      MapSet.member?(seen, index) ->
        {:loop, {index, acc, seen}}

      true ->
        solve1(input, run(inst, {index, acc, seen}))
    end
  end

  def brute_force([val | tail], input) do
    modifed =
      List.update_at(input, val, fn
        [cmd, "jmp", val] -> [cmd, "nop", val]
        [cmd, "nop", val] -> [cmd, "jmp", val]
      end)

    case solve1(modifed, {0, 0, MapSet.new()}) do
      {:loop, _} -> brute_force(tail, input)
      {:end, result} -> result
    end
  end

  def run([_, "acc", val], {index, acc, seen}),
    do: {index + 1, acc + String.to_integer(val), MapSet.put(seen, index)}

  def run([_, "jmp", val], {index, acc, seen}),
    do: {index + String.to_integer(val), acc, MapSet.put(seen, index)}

  def run([_, "nop", _], {index, acc, seen}), do: {index + 1, acc, MapSet.put(seen, index)}
end

Day8.solve()
