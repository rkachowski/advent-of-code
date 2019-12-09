require 'pry-byebug'
file = "input"
input = File.open(file).read.chomp.chars
width, height = 25, 6

layers = input.each_slice(width * height).map{ |s| s.each_slice(width).to_a }
min_layer = layers.min {|l,l2| l.flatten.count("0") <=> l2.flatten.count("0")}
puts min_layer.flatten.count("1") * min_layer.flatten.count("2")

first = layers.pop
layers.reverse.each do |cur_layer|
  cur_layer.each_with_index do |row, row_number|
    row.each_with_index do |pix,i|
      first[row_number][i] = pix if pix == "1" or pix == "0"
    end
  end
end

puts first.map {|l|l.join.gsub('0','.')}
