defmodule Main do
  def run() do
    input =
      "input"
      |> File.read!()
      |> String.graphemes()

    input |> scan(4) |> IO.puts()
    input |> scan(14) |> IO.puts()
  end

  def scan(input, chunk) do
    index =
      input
      |> Enum.chunk_every(chunk, 1, :discard)
      |> Enum.find_index(fn str ->
        result = for s <- str, into: MapSet.new(), do: s

        MapSet.size(result) == chunk
      end)

    index + chunk
  end
end

Main.run()
