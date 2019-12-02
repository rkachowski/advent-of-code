input = File.open("input").read.lines
input.map!{|l| l.split(",").map(&:to_i)}


=begin
test = "1, 1
1, 6
8, 3
3, 4
5, 5
8, 9".lines
test.map!{|l| l.split(",").map(&:to_i)}
input = test
=end

max_x, max_y =  input.map{|c| c[0]}.max, input.map{|c| c[1]}.max

$grid = Array.new((max_x / 100.0).ceil * 100) { Array.new((max_y / 100.0).ceil * 100) }
$safe_zone_size = 0
distance = ->(a,b){ ((a[0] - b[0]).abs + (a[1] - b[1]).abs) }

0.upto($grid.first.size-1) do |y|
  0.upto($grid.size-1) do |x|
    distances = input.each_with_object([]) { |c, map| map << distance.call([x,y],c)}
    min = distances.min

    if distances.count(min) > 1
      $grid[x][y] = "."
    else
      $grid[x][y] = distances.index(min)
    end

    $safe_zone_size += 1 if distances.reduce(:+) < 10000
  end
end

infinites = ($grid.map {|c| c.first} + $grid.map {|c| c.last} + $grid.first + $grid.last).uniq
remain = $grid.flatten.delete_if {|c| infinites.include? c }

counts = remain.each_with_object(Hash.new(0)){|o,h| h[o] += 1 }
puts counts.values.max
puts $safe_zone_size


binding.pry
puts "woop"
