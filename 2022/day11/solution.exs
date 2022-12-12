defmodule Main do
  def run(file \\ "test") do
    monkeys =
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> parse_monkeys()

    monkey_round(monkeys)
  end

  def monkey_round(monkeys) do
    0..map_size(monkeys)
    |> Enum.reduce(monkeys, fn i, monkeys ->
      current_monkey = monkeys[i]


    end)

  end

  def op(str, old) do
    {r, _} = Code.eval_string(str, old: old)
    r
  end

  def parse_monkeys(input) do
    input
    |> Enum.reduce([], fn
      "Monkey " <> monkey_number, acc ->
        id = String.trim_trailing(monkey_number, ":")
        [%{id: id, inspected: 0} | acc]

      "Starting items: " <> items, [hd | tl] ->
        [Map.put(hd, :items, String.split(items, ", ")) | tl]

      "Operation: new = " <> operation, [hd | tl] ->
        [Map.put(hd, :op, operation) | tl]

      "Test: divisible by " <> num, [hd | tl] ->
        [Map.put(hd, :test, num) | tl]

      "If true: throw to monkey " <> id, [hd | tl] ->
        [Map.put(hd, true, id) | tl]

      "If false: throw to monkey " <> id, [hd | tl] ->
        [Map.put(hd, false, id) | tl]
    end)
    |> Enum.into(%{}, fn i = %{id: id} -> {id, i} end)
  end
end

Main.run()
