input = File.open("input").read.lines.map { |l| l.scan(/(-?\d+),\s+(-?\d+)/).flatten.map(&:to_i) }


def iterate list
  list.map! {|x,y,vx,vy| [x+vx,y+vy,vx,vy]}
end

def get_bounds list
  minx, maxx = list.map{|x,_,_,_|x}.min, list.map{|x,_,_,_|x}.max
  miny, maxy = list.map{|_,y,_,_|y}.min, list.map{|_,y,_,_|y}.max
  [minx, maxx, miny, maxy]
end

def display list
  minx, maxx, miny, maxy = get_bounds list

  miny.upto(maxy) do |y|
    minx.upto(maxx) do |x|
      if list.any? { |xc,yc,_,_| x == xc and y == yc }
        print "#"
      else
        print "."
      end
    end
      puts ""
  end
end
secs = 0
loop do
  secs +=1
  iterate input
  bounds = get_bounds(input)
  if bounds[1] - bounds[0] < 70
    puts secs
    display input
    gets
  end
end
