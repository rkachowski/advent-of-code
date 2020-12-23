defmodule Day10 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.to_integer(&1)))
    |> Enum.sort
  end

  def solve do
    input = parse("input")

    {_, map} = find_adaptors(input, 0, %{1=> 0, 3=>0})
    IO.puts map[1] * map[3]


    to_steps([ 0 | input], [])
    |> find_runs([1])
    |> Enum.map(&(find_ways(&1)))
    |> Enum.reduce(1, &(&1 * &2))
    |> IO.puts
    require IEx; IEx.pry
  end

  def to_steps([ _ | []], acc), do: Enum.reverse(acc)
  def to_steps(input = [h | tail], acc) do
    [next | _ ] = tail
    to_steps tail, [next - h | acc]
  end

  def find_runs([ _ | []], acc), do: Enum.filter(acc, &(&1 > 1))
  def find_runs(input, []), do: find_runs(input, [0])
  def find_runs [h | list], acc = [run_length | tail] do
    [next | _ ] = list
    run_length = run_length || 0

    acc = case next do
      1 when next == h -> [run_length + 1 | tail]
      1 when next != h -> [ 1 | acc]
      _ -> acc
    end

    find_runs list, acc
  end

  def find_ways(n) when n in [1,0], do: 1
  def find_ways(2),do: 2
  def find_ways(n), do: find_ways(n-1) + find_ways(n-2) + find_ways(n-3)

  def find_adaptors([], current, differences), do:
    {current + 3, %{differences | 3 => differences[3] + 1 }}
  def find_adaptors([h | t], current, differences), do:
    find_adaptors t, h, %{differences | h - current => differences[h - current] + 1 }
end

Day10.solve
