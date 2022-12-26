defmodule Main do
  def run(filename \\ "test") do
    total =
      filename
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&convert/1)
      |> Enum.sum()

    total |> IO.puts()

    total
    |> to_snafu()
    |> IO.puts()
  end

  def convert(line) do
    {result, _} =
      line
      |> Enum.map(&to_dec/1)
      |> Enum.reverse()
      |> Enum.reduce({0, 0}, fn num, {sum, power} ->
        converted = num * 5 ** power
        {sum + converted, power + 1}
      end)

    result
  end

  def to_dec("-"), do: -1
  def to_dec("="), do: -2
  def to_dec(n), do: String.to_integer(n)

  def to_snafu_char(4), do: "-"
  def to_snafu_char(3), do: "="
  def to_snafu_char(n), do: to_string(n)

  def to_snafu(num, str \\ "")
  def to_snafu(0, str), do: str

  def to_snafu(num, str) do
    char = rem(num, 5) |> to_snafu_char()
    sub = num - to_dec(char)
    next = div(sub, 5)
    to_snafu(next, char <> str)
  end
end

Main.run("input")
