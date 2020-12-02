defmodule Pass do
  defstruct pass: "", regex: nil, min: 0, max: 0, char: ""
end

defmodule Day2 do
  def parse do
    {_, file} = File.read("input")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.split(": ", trim: true)))
    |> Enum.map( fn [pol, pass] ->
        [o, c] = String.split(pol, " ", trim: true)
        [min, max] = String.split(o, "-", trim: true) |> Enum.map(&(&1 |> String.to_integer))

        {_result, regex} = Regex.compile c
        
        %Pass{pass: pass, char: c, regex: regex, min: min, max: max}
      end)
  end

  def part1(input) do
    result = input |>
      Enum.reduce(0, fn item = %Pass{min: min, max: max}, acc ->
        case Regex.scan(item.regex, item.pass) do
          x when length(x) <= max and length(x) >= min ->
            acc + 1
          x when is_number(length(x)) ->
            acc
          nil ->
            acc
        end
      end)
    
    IO.puts result
  end

  def part2(input) do
    result = input
    |> Enum.reduce(0, fn item = %Pass{min: min, max: max, char: char}, acc ->
        first = String.at item.pass, min-1
        second = String.at item.pass, max-1

        if (first == char or second == char) and first != second do
          acc + 1
        else 
          acc
        end
      end)
    IO.puts result
  end

  def solve do
    input = parse()

    part1(input)
    part2(input)
  end
end

Day2.solve