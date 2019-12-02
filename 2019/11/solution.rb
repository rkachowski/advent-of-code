$sat = Array.new(300){ Array.new(300,0) }

$input = 5034

def power_for_coord x,y,serial
  rack = x + 10
  power = rack * y
  power += serial
  power *= rack
  ((power / 100) % 10) - 5
end

def iterate_grid(max=299)
  0.upto(max) do |y|
    0.upto(max) do |x|
      yield(x,y)
    end
  end
end


def sat_value x,y,grid
  a = y-1 >= 0 ? grid[x][y-1] : 0
  b = x-1 >= 0 ? grid[x-1][y] : 0
  c = (x-1 >= 0 and y-1 >= 0) ?  grid[x-1][y-1] : 0

  a + b - c
end

#populate summed area table
iterate_grid { |x,y| $sat[x][y] = power_for_coord(x, y, $input)+sat_value(x,y,$sat)}

def access x,y,grid
  return grid[x][y] if x >= 0 and y >= 0
  0
end

def sat_cost x, y, size,sat=$sat
  access(x+size,y+size,sat) + access(x-1,y-1,sat) - access(x+size,y-1,sat) - access(x-1,y+size,sat)
end

#find max 3x3 area
max = [0,0,0]
iterate_grid do |x,y|
  next if x + 2 >= 299 or y + 2 >= 299
  if sat_cost(x,y,2) > max[2]
    max = [x,y, sat_cost(x,y,2) ]
  end
end

puts max.join(",")

#part 2

#find max nxn area
result = [nil,nil,0,0]
1.upto(298) do |x|
  1.upto(298) do |y|
    1.upto(17).each do |size|
      next if x+size >=300 or y+size >= 300
      if sat_cost(x,y,size) > result[3]
        result = [x,y,size,sat_cost(x,y,size) ]
      end
    end
  end
end

x,y,size,_ = result
puts "#{x},#{y},#{size+1}"
