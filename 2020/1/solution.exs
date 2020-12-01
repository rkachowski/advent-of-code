defmodule Day1 do

    def solve do 
        {_, file} = File.read("input")

        input = file |>
            String.split("\n",trim: true) |>
            Enum.map(&String.to_integer/1) |>
            MapSet.new

        part1 input
    end

    def part1(input) do
        result = Enum.find(input, &(MapSet.member?(input, abs(2020 - &1))))
        IO.puts "got pair #{result} and #{abs(2020 - result)} - #{result * (abs(2020-result))}"
    end

    def part2(input) do
     
    end
end


Day1.solve
