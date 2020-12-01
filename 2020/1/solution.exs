defmodule Day1 do

    def solve do 
        {_, file} = File.read("input")

        input = file |>
            String.split("\n",trim: true) |>
            Enum.map(&String.to_integer/1) |>
            MapSet.new

        part1 input
        part2 input
    end

    def part1(input) do
        result = Enum.find(input, &(MapSet.member?(input, abs(2020 - &1))))
        IO.puts "got pair #{result} and #{abs(2020 - result)} - #{result * (abs(2020-result))}"
    end

    def part2(input) do
        Enum.reduce_while(input, MapSet.to_list(input), fn _, acc ->
            [i | tail] = acc
            j = Enum.filter(acc, &(i + &1 < 2020))

            result = Enum.find(j, :not_found, &(MapSet.member?(input, abs(i + &1 - 2020))))

            if result == :not_found do
                {:cont, tail}
            else
                third = abs(i + result - 2020)
                IO.puts "#{i} - #{result} - #{third} - #{i * result * third}"

                {:halt, "lol"}
            end
        end)
    end
end


Day1.solve
