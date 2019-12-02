input = File.open("input").read.lines.map(&:to_i)


def fuel mass
  (mass / 3.0).floor - 2
end

def all_fuel mass
  total = 0
  cost = mass

  loop do
    cost = fuel(cost)
    break if cost <= 0
    total += cost
  end

  total
end

puts input.map{|f| fuel(f)}.sum


puts input.map{|f| all_fuel(f)}.sum
