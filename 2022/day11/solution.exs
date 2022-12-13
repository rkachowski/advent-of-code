defmodule Main do
  def run(file \\ "input") do
    monkeys =
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> parse_monkeys()

    monkeys |> do_rounds(20, &div(&1, 3)) |> IO.inspect()

    pt2_div =
      monkeys
      |> Map.values()
      |> Enum.map(fn monkey -> monkey[:test] end)
      |> Enum.product()

    monkeys |> do_rounds(10000, &rem(&1, pt2_div)) |> IO.inspect()
  end

  def do_rounds(monkeys, round_count, divider) do
    [a, b | _] =
      0..(round_count - 1)
      |> Enum.reduce(monkeys, fn _round_number, round ->
        monkey_round(round, divider)
      end)
      |> Enum.map(fn {_, %{inspected: i}} -> i end)
      |> Enum.sort()
      |> Enum.reverse()

    a * b
  end

  def monkey_round(monkeys, divider \\ 3) do
    0..(map_size(monkeys) - 1)
    |> Enum.reduce(monkeys, fn thrower, round ->
      monkey =
        %{items: items, op: operation, test: test, true: t, false: f} =
        Map.get(round, to_string(thrower))

      items
      |> Enum.reduce(round, fn item, acc ->
        worry = inspect_item(operation, item, divider)

        to_receive =
          if rem(worry, test) == 0 do
            t
          else
            f
          end

        acc
        |> update_in([to_receive, :items], &(&1 ++ [worry]))
        |> update_in([monkey[:id], :inspected], &(&1 + 1))
      end)
      |> put_in([monkey[:id], :items], [])
    end)
  end

  def inspect_item(str, old, divider) do
    {r, _} = Code.eval_string(str, old: old)
    divider.(r)
  end

  def parse_monkeys(input) do
    input
    |> Enum.reduce([], fn
      "Monkey " <> monkey_number, acc ->
        id = String.trim_trailing(monkey_number, ":")
        [%{id: id, inspected: 0} | acc]

      "Starting items: " <> items, [hd | tl] ->
        ints =
          items
          |> String.split(", ")
          |> Enum.map(&String.to_integer/1)

        [Map.put(hd, :items, ints) | tl]

      "Operation: new = " <> operation, [hd | tl] ->
        [Map.put(hd, :op, operation) | tl]

      "Test: divisible by " <> num, [hd | tl] ->
        [Map.put(hd, :test, String.to_integer(num)) | tl]

      "If true: throw to monkey " <> id, [hd | tl] ->
        [Map.put(hd, true, id) | tl]

      "If false: throw to monkey " <> id, [hd | tl] ->
        [Map.put(hd, false, id) | tl]
    end)
    |> Enum.into(%{}, fn i = %{id: id} -> {id, i} end)
  end
end

Main.run("input")
