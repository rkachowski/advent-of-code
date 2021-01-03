defmodule Day25 do
  def transform(num, subject,goal), do: transform(num, subject,goal,1)
  def transform(num, subject, goal, times) do
    val = rem(num * subject, 20201227)
    if val == goal, do: times, else: transform(val, subject,goal, times+1)
  end

  def solve do
    input = [3418282,8719412]
    [card, door] = input

    door_loop_size = transform(1,7,door)

    Enum.reduce(1..(door_loop_size), 1, fn _,v ->
      rem(v * card, 20201227)
    end)
  end
end
