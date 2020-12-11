defmodule Day8 do
  def parse do
    File.read("input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/(\w+)\s((?:\+|-)\d+)/, &1, capture: :all_but_first))
  end

  def solve do
    input = parse()

    {:loop_detected, {_, acc, _}} = run_program(input, {0, 0, MapSet.new()})
    IO.puts(acc)

    modifiable =
      input
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {[x, _], i}, acc when x in ~w(jmp nop) -> [i | acc]
        {_, _}, acc -> acc
      end)

    brute_force(modifiable, input)
    |> elem(1)
    |> IO.puts()
  end

  def run_program(instructions, {index, acc, seen}) when index >= length(instructions),
    do: {:end, {index, acc, seen}}

  def run_program(instructions, {index, acc, seen}) do
    inst = Enum.at(instructions, index)

    cond do
      MapSet.member?(seen, index) ->
        {:loop_detected, {index, acc, seen}}

      true ->
        run_program(instructions, run(inst, {index, acc, seen}))
    end
  end

  def brute_force([val | tail], input) do
    modified =
      List.update_at(input, val, fn
        ["jmp", val] -> ["nop", val]
        ["nop", val] -> ["jmp", val]
      end)

    case run_program(modified, {0, 0, MapSet.new()}) do
      {:loop_detected, _} -> brute_force(tail, input)
      {:end, result} -> result
    end
  end

  def run(["acc", val], {index, acc, seen}),
    do: {index + 1, acc + String.to_integer(val), MapSet.put(seen, index)}

  def run(["jmp", val], {index, acc, seen}),
    do: {index + String.to_integer(val), acc, MapSet.put(seen, index)}

  def run(["nop", _], {index, acc, seen}), do: {index + 1, acc, MapSet.put(seen, index)}
end

Day8.solve()
