require 'set'

input = File.open("input").read.lines.map(&:to_i)
puts "part1 #{input.reduce(:+)}"

val = 0
set = Set.new([val])
0.step.each do |i|
  index = i % input.size
  val = val + input[index]
  if set.member? val; puts "part2 #{val}"; exit; end
  set << val
end

