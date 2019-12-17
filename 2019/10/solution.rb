require 'pry-byebug'
require 'set'

file = "test2"
input = File.open(file).read.lines.map {|l| l.chomp.chars }

def iterate_grid grid, p=false
  grid.size.times do |y|
    grid.first.size.times do |x|
      r = yield(x,y, grid[y][x])
      print r if p
    end
    puts "" if p
  end
end

def get_asteroids inp
  result = Set.new

  iterate_grid(inp) { |x,y,a| result << [x,y] if a == "#"}

  result
end

def dda p1, p2
  dx = p2[0] - p1[0]
  dy = p2[1] - p1[1]

  steps = dx.abs > dy.abs ? dx.abs : dy.abs

  xinc = dx / steps.to_f;
  yinc = dy / steps.to_f;

  steps.times.to_a.map {|i| [(p1[0] + (i+1) * xinc).round, (p1[1] + (i+1) * yinc).round]}
end


def cells p1, p2
  return [] if p1 == p2

  xdiff = p2[0] - p1[0]
  ydiff = p2[1] - p1[1]

  dx = xdiff / xdiff.gcd(ydiff)
  dy = ydiff / xdiff.gcd(ydiff)
  result = []
  x,y = p1.clone

  loop do
   result << [x,y]
   break if x == p2[0] and y == p2[1]

   x += dx
   y += dy

  end

  result
end
def visible asteroid, asteroids

  seen = Set.new
  asteroids.each do |other|
    points = cells(asteroid,other)

    points.each do |p|
      next if p == asteroid
      if asteroids.member? p
        seen << p
        break
      end
    end
  end

  seen
end

def polar cart
  [Math.sqrt( cart[0]**2 + cart[1]**2 ), Math.atan2(cart[1],cart[0])]
end

asteroids = get_asteroids input

scores = asteroids.map { |a| [visible(a, asteroids), a] }

visible, location = scores.max {|c,b| c[0].size <=> b[0].size}
binding.pry
puts visible

polar = visible.to_a.map {|d| polar([d[0] - location[0],d[1] - location[1]]) + [d] }
#get the list of all visible, sorty by the angle and slowly remove them from the list until complete, then restart until get to 200
