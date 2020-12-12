defmodule Day12 do
  @directions [{1,0},{0,1},{-1,0},{0,-1}]

  def  parse(input \\ "input") do
    File.read(input)
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&(Regex.run(~r/(\w)(\d+)/,&1, capture: :all_but_first)))
    |> Enum.map(fn [c, v] -> [c, String.to_integer(v)] end)
  end

  def solve do
    input = parse()
    position = {0,0}
    {{x,y}, _} = Enum.reduce(input,{position, 0} , &(move(&1,&2)))
    IO.puts abs(x) + abs(y)

    waypoint = {10, -1}

    {{x,y}, _} = Enum.reduce(input,{position, waypoint}, &(part2(&1,&2)))
    IO.puts abs(x) + abs(y)
  end

  def part2([c, val], {position,  waypoint}) do
    case c do
      "F" -> {mult(position, waypoint, val), waypoint}
      n when n in ~w(L R) ->
        {position, rotate([c,val], waypoint)}
      n when n in ~w(N E S W) ->
        {waypoint, _} = move([c, val], {waypoint, 0})
        {position, waypoint}
    end
  end

  def rotate ["L" , val], point do
    Enum.reduce(0..(div(val,90)-1), point, fn _, point -> { elem(point,1), -elem(point,0)} end)
  end

  def rotate ["R" , val], point do
    Enum.reduce(0..(div(val,90)-1), point, fn _, point -> { -elem(point,1), elem(point,0)} end)
  end

  def move(["F", val], {position, dir}) do
    position = mult(position, Enum.at(@directions, dir), val)
    {position,dir}
  end

  def move(["R", val], {position, dir}) do
    i = Integer.mod(dir + div(val, 90),4)
    {position,i}
  end

  def move(["L", val], {position, i}) do
    i = Integer.mod(i - div(val, 90), 4)
    {position,i}
  end

  def move([d, val], {position, i}) when d in ~w(N E S W) do
    dir = case d do
      "N" -> {0,-1}
      "E" -> {1,0}
      "S" -> {0,1}
      "W" -> {-1,0}
    end

    {mult(position, dir, val),i}
  end

  def mult({a,b},{c,d},val), do: {a + c * val,b + d * val}
end

Day12.solve
