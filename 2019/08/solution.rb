require 'pry-byebug'
file = "input"
input = File.open(file).read.chomp.chars
width, height = 25, 6

layers = input.each_slice(width * height).map{ |s| s.each_slice(width).to_a }
min_layer = layers.min {|l,l2| l.flatten.count("0") <=> l2.flatten.count("0")}

binding.pry
puts min_layer.flatten.count("1") * min_layer.flatten.count("2")

#replace 2 with nil, 1 with white and 0 with black
