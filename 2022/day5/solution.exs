defmodule Main do
  def parse_input(file \\ "input") do
    lines = file |> File.read!() |> String.split("\n", trim: true)

    %{stack: stack, instr: instr} =
      lines
      |> Enum.reduce(
        %{stack: [], instr: []},
        fn line, acc = %{stack: s, instr: i} ->
          case parse_line(line) do
            {:stack, setup} -> %{acc | stack: [setup | s]}
            {:instructions, instr} -> %{acc | instr: [instr | i]}
            _ -> acc
          end
        end
      )

    %{stack: Enum.reverse(stack), instr: Enum.reverse(instr)}
  end

  def parse_line(line) do
    cond do
      String.match?(line, ~r/\[\w\]/) -> {:stack, parse_stack(line)}
      String.match?(line, ~r/move/) -> {:instructions, parse_instr(line)}
      true -> nil
    end
  end

  def parse_stack(line) do
    vals = Regex.scan(~r/(\w)/, line) |> Enum.map(&hd/1)

    indices =
      Regex.scan(~r/(\w)/, line, return: :index)
      |> Enum.map(fn [{i, _}, _] -> i end)
      |> Enum.map(&(((&1 / 4) |> floor()) + 1))

    Enum.zip(vals, indices)
  end

  def parse_instr(str) do
    Regex.scan(~r/(\d+)/, str) |> Enum.map(&(&1 |> hd() |> String.to_integer()))
  end

  def build_stack(setup) do
    size = setup |> List.flatten() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    stacks = for s <- 1..size, into: %{}, do: {s, []}

    setup
    |> List.flatten()
    |> Enum.reduce(stacks, fn {l, s}, stack ->
      Map.put(stack, s, [l | stack[s]])
    end)
    |> Enum.into(%{}, fn {k, v} -> {k, Enum.reverse(v)} end)
  end

  def run() do
    %{stack: stack, instr: instructions} = parse_input()

    part1 = build_stack(stack)

    result =
      instructions
      |> Enum.reduce(part1, fn [count, from, to], acc ->
        acc |> move(from, to, count)
      end)

    str = for i <- 1..map_size(result), into: "", do: hd(result[i])
    str |> IO.puts()

    part2 = build_stack(stack)

    result =
      instructions
      |> Enum.reduce(part2, fn [count, from, to], acc ->
        acc |> move2(from, to, count)
      end)

    str = for i <- 1..map_size(result), into: "", do: hd(result[i])
    str |> IO.puts()
  end

  def move(stack, _from, _to, 0), do: stack

  def move(stack, from, to, count) do
    stack |> move(from, to) |> move(from, to, count - 1)
  end

  def move(stack, from, to) do
    [h | t] = stack[from]

    stack |> Map.put(from, t) |> Map.put(to, [h | stack[to]])
  end

  def move2(stack, from, to, count) do
    {h, t} = Enum.split(stack[from], count)

    stack |> Map.put(from, t) |> Map.put(to,  h ++ stack[to])
  end
end

Main.run()
