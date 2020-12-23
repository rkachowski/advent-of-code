require IEx

defmodule Day19 do
  def parse(input \\ "input") do
    [rules, codes] = File.read(input)
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))

    rules = rules
    |> Enum.reduce(%{}, fn str,map ->
      [_, rule_num, rule_components] = Regex.run(~r/(\d+): (.*)$/, str)
      Map.put(map, rule_num, rule_components)
    end)

    {rules, codes}
  end

  #shamelessly taken from https://www.reddit.com/r/adventofcode/comments/kg1mro/2020_day_19_solutions/ggcamlq/?
  def compile_regex_for_key(rule_map, key \\ "0", doing_p2 \\ false)
  def compile_regex_for_key(_, "\"a\"", _), do: "a"
  def compile_regex_for_key(_, "\"b\"", _), do: "b"
  def compile_regex_for_key(_, "|", _), do: "|"

  def compile_regex_for_key(rule_map, "8", true) do
    "(#{
      rule_map
      |> Map.get("42")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    })+"
  end

  def compile_regex_for_key(rule_map, "11", true) do
    ident = "a#{:rand.uniform(1000) |> Integer.to_string()}"

    "(?'#{ident}'(#{
      rule_map
      |> Map.get("42")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    })(?&#{ident})?(#{
      rule_map
      |> Map.get("31")
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, true))
    }))"
  end

  def compile_regex_for_key(rule_map, key, is_p2?) do
    rule =
      rule_map
      |> Map.get(key)
      |> String.split(" ", trim: true)
      |> Enum.map(&compile_regex_for_key(rule_map, &1, is_p2?))

    case Enum.count(rule) do
      1 -> hd(rule)
      _ -> "(#{rule})"
    end
  end

  def solve do
    {rules, messages} = parse()
    {:ok, r} = "^" <> compile_regex_for_key(rules, "0") <> "$" |> Regex.compile
    Enum.filter(messages, &( &1 =~ r )) |>  Enum.count |> IO.puts

    rules = rules |> Map.put("8", "42 | 42 8") |> Map.put("11", "42 31 | 42 11 31")
    {:ok, r} = "^" <> compile_regex_for_key(rules, "0", true) <> "$" |> Regex.compile
    Enum.filter(messages, &( &1 =~ r )) |>  Enum.count |> IO.puts
  end
end
