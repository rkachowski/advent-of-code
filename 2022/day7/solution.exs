defmodule Main do
  def parse_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def run() do
    input = parse_input("input")

    dir_tree = input |> build_dir_tree()
    {sizes, total_size} = calc_sizes(dir_tree["/"], %{}, "/")

    sizes |> part1() |> IO.inspect()
    sizes |> part2(total_size) |> IO.inspect()
  end

  def build_dir_tree(input) do
    input
    |> Enum.reduce(%{"/" => %{}, _dir: ["/"]}, fn line, tree ->
      add_entry(tree, line)
    end)
    |> Map.delete(:_dir)
  end

  def add_entry(tree, "$ cd /"), do: tree

  def add_entry(tree = %{_dir: pwd}, "$ cd ..") do
    {_, new_dir} = List.pop_at(pwd, -1)
    %{tree | _dir: new_dir}
  end

  def add_entry(tree = %{_dir: pwd}, "$ cd " <> new_dir) do
    %{tree | _dir: pwd ++ [new_dir]}
  end

  def add_entry(tree, "$ ls"), do: tree

  def add_entry(tree = %{_dir: pwd}, "dir " <> dir) do
    case get_in(tree, pwd) do
      nil -> put_in(tree, pwd, %{dir => %{}})
      map -> put_in(tree, pwd, Map.put(map, dir, %{}))
    end
  end

  def add_entry(tree = %{_dir: pwd}, file) do
    [size, name] = file |> String.split(" ")
    size = size |> String.to_integer()

    case get_in(tree, pwd) do
      nil -> put_in(tree, pwd, %{name => size})
      map -> put_in(tree, pwd, Map.put(map, name, size))
    end
  end

  def part1(sizes) do
    sizes
    |> Map.values()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part2(sizes, total_size) do
    max_space = 70_000_000
    required_space = 30_000_000

    to_free = total_size - (max_space - required_space)

    sizes
    |> Map.values()
    |> Enum.filter(&(&1 > to_free))
    |> Enum.min()
  end

  def calc_sizes(tree, sizes, path) do
    {all_sizes, size} =
      tree
      |> Enum.reduce({sizes, 0}, fn
        {dir_name, dir_map}, {sizes, current_size} when is_map(dir_map) ->
          {subdir_contents, subdir_size} = calc_sizes(dir_map, sizes, path <> "/" <> dir_name)

          {subdir_contents, current_size + subdir_size}

        {_file_name, size}, {sizes, current_size} ->
          {sizes, current_size + size}
      end)

    {Map.put(all_sizes, path, size), size}
  end
end

Main.run()
