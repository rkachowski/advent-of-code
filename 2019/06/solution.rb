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

def all_children node
  return [] unless node.children.size > 0
  
  (node.children + node.children.map {|c| all_children(c)}).flatten.uniq
end



def find_common_parent n1, n2
  parents = {}
  nodes  = [n1.parent, n2.parent]

  loop do
    nodes.map! do |n_p|
      if parents[n_p.name]
        return parents[n_p.name]
      else
        parents[n_p.name] = n_p
      end
      n_p ? n_p.parent : nil
    end

    nodes.compact!
  end
end

you, santa = @map["YOU"], @map["SAN"]
common_ancestor = find_common_parent you, santa

puts (root_distance(you) - root_distance(common_ancestor) - 1) + (root_distance(santa) - root_distance(common_ancestor) - 1)
