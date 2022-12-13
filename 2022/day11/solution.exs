defmodule Main do
  def run(file \\ "input") do
    monkeys =
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> parse_monkeys()

    [a,b | _] =
      0..19
      |> Enum.reduce(monkeys, fn _round_number, round ->
        monkey_round(round)
      end)
      |> Enum.map(fn {_, %{inspected: i}} -> i end)
      |> Enum.sort()
      |> Enum.reverse()

      IO.puts(a*b)
    dbg()
  end

  def monkey_round(monkeys) do
    0..(map_size(monkeys) - 1)
    |> Enum.reduce(monkeys, fn thrower, round ->
      monkey =
        %{items: items, op: operation, test: test, true: t, false: f} =
        Map.get(round, to_string(thrower))

      items
      |> Enum.reduce(round, fn item, acc ->
        worry = op(operation, item)

        to_receive =
          if rem(worry, test) == 0 do
            t
          else
            f
          end

        acc
        |> update_in([to_receive, :items], &(&1 ++ [worry]))
        |> update_in([to_string(thrower), :inspected], &(&1 + 1))
      end)
      |> put_in([to_string(thrower), :items], [])
    end)
  end

  def op(str, old) do
    {r, _} = Code.eval_string(str, old: old)
    div(r, 3)
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

Main.run()
