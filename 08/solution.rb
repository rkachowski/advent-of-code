input = File.open("input").read.split.map(&:to_i)

def node data
  child_count, metadata_count = data.shift, data.shift
  children = []
  metadata = []
  child_count.times { children << node(data) }
  metadata_count.times { metadata << data.shift }
  {children:children, metadata:metadata}
end

def metadata_sum tree
  tree[:metadata].reduce(:+) + (tree[:children].map {|c| metadata_sum(c)}.flatten.reduce(:+) || 0)
end

def node_value node
  if node[:children].empty?
    node[:metadata].reduce(:+)
  else
    child_values = node[:metadata].map do |m|
      index = m - 1
      if index >= 0 and node[:children][index]
        node_value(node[:children][index])
      else
        0
      end
    end
    child_values.reduce(:+)
  end
end

tree = node(input)
puts metadata_sum(tree)
puts node_value(tree)

