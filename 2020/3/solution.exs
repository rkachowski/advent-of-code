defmodule Day3 do

    def parse do
        {_, file} = File.read("input")

        file 
        |> String.split("\n",trim: true) 
        |> Enum.map(&String.graphemes/1) 
        |> Enum.map(&Grid.line_to_row/1)
        |> Grid.line_to_row
    end

    def solve do
        g = Grid.new(parse(), true)

        IO.puts trees_for_slope(g, 3, 1)
        
        slopes = [{1,1},{3,1},{5,1},{7,1},{1,2}]
        |> Enum.map(fn {x,y} -> trees_for_slope(g, x, y) end)
        |> Enum.reduce(1, &(&1 * &2))
        
        IO.puts slopes
    end

    def trees_for_slope grid, x, y do
        0..grid.height
        |> Enum.take_every(y)
        |> Enum.with_index
        |> Enum.reduce([],fn {v, i}, acc -> [ Grid.get(grid,i*x, v) | acc] end)
        |> Enum.count(&(&1 == "#"))
    end
end

Day3.solve