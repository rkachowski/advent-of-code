require 'pry-byebug'
require "ostruct"

file = "input"
input = File.open(file).read.lines.map{|l| l.chomp.split(")") }

l, r = input.transpose
root_name = (l - r).first

def new_node name
  s = OpenStruct.new name:name, children:[], parent:nil
  @map[s.name] = s
  s
end

@map = {}
@root = new_node root_name

loop do
  break if input.size == 0
  p, n = input.shift

  child_node = @map[n]
  unless child_node
    child_node = new_node n
  end

  parent_node = @map[p]
  unless parent_node
    parent_node = new_node p
  end

  child_node.parent = parent_node
  parent_node.children << child_node
end

def root_distance node, distance = 1
  return 0 if node == @root
  1 + root_distance(node.parent, distance + 1)
end

puts @map.values.sum {|n| root_distance(n)}

