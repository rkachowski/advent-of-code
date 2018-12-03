input = File.open("input").read.lines
positions = input.map do |i|
  x,y = i.scan(/(\d+),(\d+)/).flatten.map(&:to_i)
  width,height = i.scan(/(\d+)x(\d+)/).flatten.map(&:to_i)
  [x,y,width,height]
end

grid = Array.new(1000) { Array.new(1000) { 0 } }

positions.each_with_index do |(x,y,width,height), id|
  height.times do |h|
    y_i = y+h
    width.times do |w|
      x_i = x + w
      grid[x_i][y_i] += 1
    end
  end
end

puts grid.flatten.select {|v| v >= 2}.count

positions.each_with_index do |(x,y,width,height), id|
  intact = true
  height.times do |h|
    y_i = y+h
    width.times do |w|
      x_i = x + w
      if grid[x_i][y_i] != 1
        intact = false
      end
    end
  end

  if intact
    puts id+1
    exit
  end
end
