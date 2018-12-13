power_grid = Array.new(300){ Array.new(300) }
total_power = Array.new(300){ Array.new(300) }

$input = 5034
def power_for_coord x,y,serial
  rack = x + 10
  power = rack * y
  power += serial
  power *= rack
  ((power / 100) % 10) - 5

end


def neighbours x,y
  [x-1,y-1,x,y-1,x+1,y-1,
  x-1,y,x,y,x+1,y,
  x-1,y+1,x,y+1,x+1,y+1]
end

def cost x,y,power
  cells = neighbours x, y
  cells.each_slice(2).to_a.map { |c| power.dig(*c) }.sum
end

300.times do |x|
  300.times do |y|
    power_grid[x][y] = power_for_coord x, y, $input
  end
end

1.upto(298) do |x|
  1.upto(298) do |y|
    total_power[x][y] = cost(x,y,power_grid)
  end
end

max = total_power.flatten.compact.max
total_power.each_with_index do |c,x|
  c.each_with_index do |v,y|
    if v == max
      puts "#{x-1}, #{y-1}"
      break
    end
  end
end
