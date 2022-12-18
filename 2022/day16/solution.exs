defmodule Main do
  def run(file \\ "test") do
    input =
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&extract_valves/1)

    dbg()
  end

  def extract_valves(line) do
    [[valve, flow, connections]] =
      ~r/([A-Z]{2}).*rate=(\d+).*valve(?:s)? (.*)/
      |> Regex.scan(line, capture: :all_but_first)

    {valve, String.to_integer(flow), String.split(connections, ", ")}
  end
end

Main.run()
