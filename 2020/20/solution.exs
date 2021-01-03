require IEx

defmodule Day20 do
  def parse(file \\ "input") do
    File.read(file)
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
    |> Enum.reduce(%{}, fn {n, g}, map -> Map.put(map, n, g) end)
  end

  def parse_tile(str) do
    [name | data] = str |> String.split("\n", trim: true)

    name = Regex.run(~r/(\d+)/, name, result: :all_but_first) |> Enum.at(0)

    {name, Grid.from_str(data)}
  end

  def solve do
    input = parse()

    connections = input |> part1 |> Enum.reduce(%{}, fn {k, v}, m -> Map.put(m, k, v) end)

    part2(input, connections) |> IO.puts()
  end

  def part1(input) do
    border_set =
      input
      |> Enum.map(fn {name, g} ->
        normal_borders = borders(g)
        reversed_borders = Enum.map(normal_borders, &Enum.reverse(&1))
        {name, MapSet.new(normal_borders ++ reversed_borders)}
      end)

    connections =
      border_set
      |> Enum.map(fn {name, borders} ->
        connecting_sides =
          Enum.reduce(border_set, [], fn
            {^name, _}, l ->
              l

            {n2, b2}, l ->
              if Enum.any?(borders, &MapSet.member?(b2, &1)), do: [n2 | l], else: l
          end)

        {name, connecting_sides}
      end)

    Enum.filter(connections, fn {_, v} -> Enum.count(v) == 2 end)
    |> Enum.map(&(elem(&1, 0) |> String.to_integer()))
    |> Enum.reduce(1, &(&1 * &2))
    |> IO.puts()

    connections
  end

  def part2(input, connections) do
    tile_map = input |> Enum.reduce(%{}, fn {n, g}, m -> Map.put(m, n, g) end)

    tile = find_and_rotate_first_corner(tile_map, connections)

    # assemble image with consistent orientation
    image = assemble_image(tile, {tile_map, connections})

    image =
      image
      # remove borders
      |> Enum.map(&Enum.map(&1, fn {g, _} -> g |> Grid.remove_borders() |> Grid.values() end))
      # concatenate grid rows
      |> Enum.map(fn l ->
        Enum.reduce(l, fn r, acc -> for {r1, r2} <- Enum.zip(acc, r), do: r1 ++ r2 end)
      end)
      # concatenate full grid
      |> Enum.reduce(&(&2 ++ &1))
      # build a new image with all components
      |> Grid.from_char_lists()

    {:ok, regex} = monster_regex(image.width)

    monster_count =
      image
      |> transform
      # find an image orientation with monster matches
      |> Enum.reduce_while(0, fn g, _ ->
        str = Grid.values(g) |> List.flatten() |> Enum.join()

        case Regex.scan(regex, str) do
          [] ->
            {:cont, nil}

          n when is_list(n) ->
            {:halt, Enum.count(n)}
        end
      end)

    hash_count =
      Grid.values(image)
      |> List.flatten()
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    hash_count - monster_count * 15
  end

  def monster_regex(width) do
    spacer = ".{#{width - 20}}"

    Regex.compile(
      "(?=..................#.#{spacer}#....##....##....####{spacer}.#..#..#..#..#..#...)"
    )
  end

  def assemble_image(top_corner, {tile_map, connections}),
    do: assemble_image(top_corner, {tile_map, connections}, [])

  def assemble_image(nil, _, acc), do: Enum.reverse(acc)

  def assemble_image(first, {tile_map, connections}, acc) do
    row = assemble_row(first, tile_map, connections)
    next_first = find_bottom(hd(row), tile_map, connections)
    assemble_image(next_first, {tile_map, connections}, [row | acc])
  end

  def find_bottom({t, name}, tile_map, connections) do
    b = bottom(t)

    Map.get(connections, name)
    |> Enum.map(&{Map.get(tile_map, &1), &1})
    |> Enum.find_value(fn {tile, connecting_name} ->
      t =
        Enum.find(transform(tile), fn t ->
          top(t) == b
        end)

      if t, do: {t, connecting_name}
    end)
  end

  def assemble_row(row = [{first, name} | _], tile_map, connections) do
    connecting_tile =
      Map.get(connections, name)
      |> Enum.map(&{Map.get(tile_map, &1), &1})
      |> Enum.find_value(fn {tile, connecting_name} ->
        r = right(first)
        t = Enum.find(transform(tile), fn t -> left(t) == r end)

        if t, do: {t, connecting_name}
      end)

    case connecting_tile do
      nil -> Enum.reverse(row)
      n -> assemble_row([n | row], tile_map, connections)
    end
  end

  def assemble_row(t, tile_map, connections), do: assemble_row([t], tile_map, connections)

  def find_and_rotate_first_corner(tile_map, connection_map) do
    {name, [b1, b2]} =
      Enum.filter(connection_map, fn {_, v} -> Enum.count(v) == 2 end)
      |> Enum.take_random(1)
      |> hd

    neighbor_transforms =
      for a <- transform(tile_map[b1]), b <- transform(tile_map[b2]), into: [], do: {a, b}

    t =
      transform(tile_map[name])
      |> Enum.find(fn g ->
        tb = bottom(g)
        tr = right(g)

        neighbor_transforms
        |> Enum.any?(fn {ii, jj} ->
          cond do
            top(ii) == tb and left(jj) == tr -> true
            top(jj) == tb and left(ii) == tr -> true
            true -> false
          end
        end)
      end)

    {t, name}
  end

  def borders(grid), do: [top(grid), bottom(grid), left(grid), right(grid)]

  def top(grid), do: for(x <- 0..(grid.width - 1), do: Grid.get(grid, x, 0))
  def bottom(grid), do: for(x <- 0..(grid.width - 1), do: Grid.get(grid, x, grid.height - 1))
  def left(grid), do: for(y <- 0..(grid.height - 1), do: Grid.get(grid, 0, y))
  def right(grid), do: for(y <- 0..(grid.height - 1), do: Grid.get(grid, grid.width - 1, y))

  def transform(grid) do
    transforms =
      Stream.cycle([
        &Grid.rotate(&1),
        &Grid.rotate(&1),
        &Grid.rotate(&1),
        &(Grid.rotate(&1) |> Grid.flip())
      ])
      |> Stream.transform(grid, fn f, g ->
        r = f.(g)
        {[r], r}
      end)
      |> Enum.take(7)

    [grid | transforms]
  end
end

Day20.solve()
