require Logger

defmodule Main do
  def run(file \\ "input") do
    input =
      file
      |> File.read!()
      |> String.split("\n", trim: true)

    input |> part1() |> IO.inspect()
  end

  def part1(input) do
    {_, _, scores} =
      input
      |> Enum.reduce({1, 1, %{}}, fn line, acc ->
        line |> run_pt1(acc) |> check_scores()
      end)

    scores |> Map.values() |> Enum.sum()
  end

  def run_pt1("noop", acc), do: inc_counter(acc)

  def run_pt1("addx " <> num, acc) do
    acc
    |> inc_counter()
    |> check_scores()
    |> then(fn {c, x, scores} ->
      {c + 1, x + String.to_integer(num), scores}
    end)
  end

  def inc_counter({cycle, x, scores}), do: {cycle + 1, x, scores}

  def check_scores({cycle, x, scores} = acc) when cycle == 20 or rem(cycle - 20, 40) == 0 do
    {cycle, x, Map.put(scores, cycle, cycle * x)}
  end

  def check_scores(acc), do: acc
end

Main.run()
