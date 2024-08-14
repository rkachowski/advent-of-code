Code.require_file("../common/grid.exs")

defmodule Main do
  def run(input \\ "test") do
    rocks = parse_rocks()
    dbg()
  end

  def parse_rocks() do
    "rocks"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&Grid.new(&1))
  end

  def step(rock, direction, map) do
    dir =
      case direction do
        :down -> {0, -1}
        :left -> {-1, 0}
        :right -> {1, 0}
      end

    new_rock = Grid.move(rock, direction)

    case outcome(new_rock, map) do
      :invalid -> {:ok, rock}
      :ok -> {:ok, new_rock}
      :done -> {:ok, new_rock}
    end
  end

  def move(rock, direction) do
    #map all keys in the direction
  end

  def outcome(rock, map) do
    # is the rock out of bounds?
      # too far left or right?
      # inside another rock?
    # is it at the bottom?
      # do the lowest parts of the rock conflict with something below?
    # otherwise cool
  end
end

Main.run()
