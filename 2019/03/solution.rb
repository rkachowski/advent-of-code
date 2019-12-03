input = File.open("input").read.lines.map{|l| l.split(",")}

grid = Array.new(20000){ Array.new(20000) }
@center = [grid.first.size / 2, grid.first.size/2]

@dirs = {
  "D" => [0,-1],
  "U" => [0,1],
  "R" => [1,0],
  "L" => [-1,0]
}

def iterate_grid grid, p=false
  grid.size.times do |y|
    grid.first.size.times do |x|
      r = yield(x,y, grid[y][x])
      print r if p
    end
    puts "" if p
  end
end

def draw_line line, grid, id
  position = @center.clone

  steps = 0
  line.each do |ex|
    dir, mag, _ = ex.partition(/\d+/)

    dir = @dirs[dir]

    0.upto(mag.to_i - 1) do
      grid[position[0]][position[1]] ||=[]
      grid[position[0]][position[1]] << [id, steps]
      steps += 1

      position[0] += dir[0]
      position[1] += dir[1]
    end
  end
end

input.each_with_index do |line, i|
  draw_line line, grid,i
end

iterate_grid(grid) do |x,y,b|
  if b 
    lines = b.map(&:first)
    if lines.uniq.size > 1
      l1, l2 = b.select{|l| l.first == 0}.map(&:last), b.select{|l| l.first == 1}.map(&:last)

      min_steps = l1.min + l2.min
      puts "crossing - #{x - @center[0]}, #{y - @center[1]} - #{(x - @center[0]).abs + (y - @center[1]).abs} - min_steps = #{min_steps}"
    end
  end
end

