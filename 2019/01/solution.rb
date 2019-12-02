require 'set'

input = File.open("input").read.lines.map(&:to_i)
puts "part1 #{input.reduce(:+)}"

0.step.inject([Set.new([0]), 0]) do |(set, val), i|
  index = i % input.size
  val = val + input[index]

  if set.member? val
    puts "part2 #{val}"
    exit
  else
    set << val
    [set, val]
  end
end

