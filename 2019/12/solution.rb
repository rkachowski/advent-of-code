require 'pry-byebug'

file = "input"
input = File.open(file).read.lines.map {|line| line.scan(/(-?\d+)/).flatten.map(&:to_i) }

velocity = Array.new(input.size)  { [0,0,0]}

@inc = ->(x,y){ return -1 if x > y; return 1 if y > x; return 0 }

def gravity moons, velocities
  moons.each_with_index do |moon,i|
    moons.each_with_index do |moon2,j|
      next if i == j
      moon.each_with_index do |v, k|
        velocities[i][k] += @inc.(moon[k],moon2[k])
      end
    end
  end
end


def do_step moons, velocities
  moons.each_with_index do |moon, i|
    moon.each_with_index do |_, j|
      moon[j] += velocities[i][j]
    end
  end
end

def energy moons, velocities
  tots = moons.map.with_index do |moon, i|
    moon.sum {|s| s.abs } * velocities[i].sum{|s| s.abs }
  end
  tots.sum
end


def gravity_single moons, velocities, index
  moons.each_with_index do |moon,i|
    moons.each_with_index do |moon2,j|
      next if i == j
        velocities[i][index] += @inc.(moon[index],moon2[index])
    end
  end
  moons.each_with_index do |moon, i|
    moon[index] += velocities[i][index]
  end
end

def steps_until_repeat moons, velocity, index


  initial = [moons.map{|m| m[index]}, velocity.map {|v|v[index]}]
  steps = 0

  loop do
    gravity_single moons, velocity, index
    steps += 1

    break if [moons.map{|m| m[index]}, velocity.map {|v|v[index]}] == initial
  end
  steps
end


#part 2
steps = 3.times.map {|i| steps_until_repeat input.clone, velocity.clone, i  }
puts steps.reduce(1, :lcm)

# part 1
1000.times { gravity input, velocity ; do_step input, velocity; puts input.inspect }
puts energy(input, velocity)
