require 'pry-byebug'

test = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"

test = "R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83"

input = test.lines.map{|l| l.split(",")}
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

  line.each do |ex|
    steps = 0
    dir, mag, _ = ex.partition(/\d+/)

    dir = @dirs[dir]

    0.upto(mag.to_i - 1) do
      begin
      grid[position[0]][position[1]] ||=[]
      grid[position[0]][position[1]] << [id, steps]

      position[0] += dir[0]
      position[1] += dir[1]
      steps += 1
      rescue Exception => e
        puts position
        puts ex
        exit
      end
    end
  end
end

input.each_with_index do |line, i|
  draw_line line, grid,i
end

iterate_grid(grid) do |x,y,b|
  if b && b.uniq.size > 1
    puts "crossing - #{x - @center[0]}, #{y - @center[1]} - #{(x - @center[0]).abs + (y - @center[1]).abs}"
  end
end

