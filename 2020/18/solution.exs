defmodule Day18 do
  def parse_ints(n), do: if(n =~ ~r/\d/, do: String.to_integer(n), else: n)

  def parse(input \\ "input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.replace(&1, "(", "( ") |> String.replace(")", " )")))
    |> Enum.map(&(String.split(&1, ~r/\s/, trim: true) |> Enum.map(fn n -> parse_ints(n) end)))
    |> Enum.map(&process(&1, []))
  end

  def solve do
    r = parse("input")
    r |> Enum.map(&ltr/1) |> Enum.sum() |> IO.puts()
    r |> Enum.map(&add/1) |> Enum.sum() |> IO.puts()
  end

  def process(["(" | l], acc) do
    [n, a] = process(l, [])
    process(n, [a | acc])
  end

  def process([")" | l], acc), do: [l, acc |> Enum.reverse()]
  def process([h | l], acc), do: process(l, [h | acc])
  def process([], acc), do: acc |> Enum.reverse()

  def ltr([v | []]), do: v
  def ltr([v | t]) when is_list(v), do: ltr([ltr(v) | t])
  def ltr([a | ["*" | [c | tail]]]) when is_number(a) and is_number(c), do: ltr([a * c | tail])
  def ltr([a | ["+" | [c | tail]]]) when is_number(a) and is_number(c), do: ltr([a + c | tail])
  def ltr([a | [b | [c | tail]]]) when is_list(c), do: ltr([a | [b | [ltr(c) | tail]]])

  def add([a | ["+" | [c | tail]]]) when is_number(a) and is_number(c), do: add([a + c | tail])
  def add([a | [b | [c | tail]]]) when is_list(c), do: add([a | [b | [add(c) | tail]]])
  def add([v | t]) when is_list(v), do: add([add(v) | t])
  def add([v | []]), do: v

  def add(l) when is_list(l) do
    case Enum.find_index(l, &(&1 == "+")) do
      nil ->
        case Enum.find_index(l, &is_list(&1)) do
          nil ->
            ltr(l)

          n ->
            {h, t} = Enum.split(l, n)
            add(h ++ List.wrap(add(t)))
        end

      n ->
        {h, t} = Enum.split(l, n - 1)
        add(h ++ List.wrap(add(t)))
    end
  end
end

Day18.solve()
