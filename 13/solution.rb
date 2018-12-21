file = "input"

input = File.open(file).read.lines.map {|c| c.chomp.chars}

$directions = {
  ">" => [0,1],
  "<" => [0,-1],
  "v" => [1,0],
  "^" => [-1,0]
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

class Car
  attr_reader :direction, :position
  attr_accessor :dead
  @@turns = [:left, :straight, :right]
  @@rotations = [[0,-1], [1,0], [0,1], [-1,0]]

  def initialize position, direction
    @current_turn = @@turns.first
    @position = position
    @direction = direction
    @dead = false
  end

  def advance(grid)
    @position = [@position[0] + @direction[0], @position[1] + @direction[1]]

    case grid[position[0]][position[1]]
    when "+"
      turn
    when "\\"
      @direction = @direction.rotate
    when '/'
      @direction = @direction.rotate.map {|c| c *= -1}
    end
  end

  def turn
    case @current_turn
    when :left
      @direction = @@rotations[(@@rotations.index(@direction) + 1) % @@rotations.size]
    when :right
      @direction = @@rotations[(@@rotations.index(@direction) - 1)]
    end

    @current_turn = @@turns[(@@turns.index(@current_turn) +  1)  % @@turns.size]
  end
end

cars = []
iterate_grid(input) do |x,y,i| 
  if $directions[i]
    cars << Car.new([y,x], $directions[i])
  end
end

loop do
  cars.sort_by!{|c| [c.position[1],c.position[0]]}
  cars.each do |c|
    next if c.dead

    c.advance(input)
    matches = cars.find_all {|cr| cr.position[0] == c.position[0] && c.position[1] == cr.position[1] && !cr.dead}
    matches.each {|cr| cr.dead = true} if matches.size > 1

    if cars.select{|c| !c.dead}.size == 1
      puts cars.select{|c| !c.dead}.first.position.rotate.join(",")
      abort
    end
  end
end
