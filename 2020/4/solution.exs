defmodule Day4 do
    @required_keys MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

    def passport_to_map passport do
        passport
        |> Enum.reduce(%{}, fn (k, acc) -> 
            [key, val] = String.split(k, ":", trim: true) 
            Map.put(acc, key, val) 
            end)
    end
    def parse do
        {_, file} = File.read("input")

        file 
        |> String.split("\n\n",trim: true) 
        |> Enum.map(&(String.split(&1, ~r{\s}, trim: true))) 
        |> Enum.map(&passport_to_map/1)               
    end

    def solve do
        input = parse()

        part1 = Enum.count(input, &valid_keys/1)

        part2 = input
        |> Enum.filter(&valid_keys/1)
        |> Enum.filter(&(Enum.all?(&1, fn {k,v} -> valid(k,v) end)))
        |> Enum.count

        IO.puts "part1 - #{part1}, part2 - #{part2}"
    end

    def valid_keys pass do
        MapSet.subset?(@required_keys, MapSet.new(Map.keys(pass)))
    end

    def valid("byr", birth) when byte_size(birth) == 4, do: String.to_integer(birth) in 1920..2002
    def valid("iyr", issue) when byte_size(issue) == 4, do: String.to_integer(issue) in 2010..2020
    def valid("eyr", issue) when byte_size(issue) == 4, do: String.to_integer(issue) in 2020..2030
    
    def valid("hcl", haircolor) when byte_size(haircolor) == 7, do: Regex.run(~r/#[0-9a-f]{6}/,haircolor) != nil
    def valid("ecl", eyecolor) when eyecolor in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], do: true
    def valid("pid", passportid) when byte_size(passportid) == 9, do: Regex.run(~r/\d{9}/, passportid) != nil
    def valid("hgt", height) do
        case Regex.run(~r/(\d+)(cm|in)/, height) do
            [_, height, "cm"] -> String.to_integer(height) in 150..193
            [_, height, "in"] -> String.to_integer(height) in 59..76
            _ -> false
        end
    end        
    def valid("cid", _), do: true
    def valid(_,_), do: false
end

Day4.solve