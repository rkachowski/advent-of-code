use Bitwise

defmodule Day14 do

  def parse(input \\ "input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, " = ", trim: true)))
    |> Enum.map(fn
      ["mask", maskval] -> {:mask, maskval}
      [memset, val] -> {:memset, Regex.run(~r/\[(\d+)\]/, memset, capture: :all_but_first), val}
    end)
  end

  def solve do
    input = parse()

    IO.puts part1(input)
    IO.puts part2(input)
  end

  def part1 input do
    {_, m} = Enum.reduce(input, {0, %{}}, fn
      {:mask, maskval},{_, map} -> {process_mask(maskval), map}
      {:memset,[addr], val}, {mask = {ones, zeros}, map} ->
        {mask, Map.put(map, addr, (String.to_integer(val) ||| ones) &&& zeros)}
    end)

    Map.values(m) |> Enum.sum
  end

  def process_mask mask do
    {String.replace(mask,"X","0") |> String.to_integer(2), String.replace(mask,"X","1") |> String.to_integer(2)}
  end

  def process_mask2 mask do
    floating = mask
    |> String.graphemes
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reject(&(elem(&1,0) != "X"))
    |> Enum.map(&(elem(&1,1)))

    {String.replace(mask,"X","0") |> String.to_integer(2), floating}
  end


  def part2 input do
     {_, m} = Enum.reduce(input, {0, %{}}, fn
      {:mask, maskval},{_, map} -> {process_mask2(maskval), map}
      {:memset,[addr], val}, {mask = {ones, floats}, map} ->
        base_addr = (String.to_integer(addr) ||| ones)

        addrs = Enum.reduce(floats, [base_addr], fn
          fl, [l | []] -> toggle_bits(l,fl)
          fl, v -> v ++ Enum.reduce(v,[],&( &2 ++ toggle_bits(&1, fl)))
        end)
        |> Enum.uniq

        map = Enum.reduce(addrs, map, &(Map.put(&2, &1, String.to_integer(val))))
        {mask, map}
    end)

    Map.values(m) |> Enum.sum
  end

  def toggle_bits val, bit do
    [ val ||| (1 <<< bit), val &&& ~~~(1 <<< bit) ]
  end
end

Day14.solve
