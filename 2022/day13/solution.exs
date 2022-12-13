defmodule Main do
  def run(file \\ "test") do
    input =
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&(Code.eval_string(&1) |> elem(0)))
      |> Enum.chunk_every(2)

    input |> part1() |> IO.puts()
    input |> part2() |> IO.puts()
  end

  def part1(input) do
    input
    |> Enum.map(&compare/1)
    |> Enum.with_index()
    |> Enum.map(fn
      {:right, i} -> i + 1
      _ -> :no
    end)
    |> Enum.filter(&(&1 != :no))
    |> Enum.sum()
  end

  @dividers [[[2]], [[6]]]
  def part2(input) do
    [d1, d2] =
      input
      |> Enum.reduce([], fn [a, b], acc -> [a, b | acc] end)
      |> Enum.concat(@dividers)
      |> Enum.sort(fn a, b -> compare(a, b) != :wrong end)
      |> Enum.with_index()
      |> Enum.map(fn
        {d, i} when d in @dividers -> i + 1
        _ -> :nope
      end)
      |> Enum.filter(&(&1 != :nope))

    d1 * d2
  end

  def compare([a, b]), do: compare(a, b)
  def compare(l, l) when is_integer(l), do: :ok

  def compare(l, r) when is_integer(l) and is_integer(r) do
    if l < r do
      :right
    else
      :wrong
    end
  end

  def compare([], r) when is_list(r), do: :right
  def compare(l, []) when is_list(l), do: :wrong
  def compare(l, r) when is_list(r) and is_integer(l), do: compare([l], r)
  def compare(l, r) when is_list(l) and is_integer(r), do: compare(l, [r])

  def compare(l = [lhd | ltl], r = [rhd | rtl]) when is_list(l) and is_list(r) do
    case compare(lhd, rhd) do
      :ok -> compare(ltl, rtl)
      n -> n
    end
  end
end

Main.run("input")
