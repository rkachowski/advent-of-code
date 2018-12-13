input = [416, 71975*100]
#test = [10, 1618]
test = [9, 25]

class Node
  attr_accessor :next, :prev, :val
  def initialize val, next_node=nil, prev=nil
    @val = val
    @next = next_node
    @prev = prev
  end
end

class LinkedList
  attr_accessor :head, :tail
  def initialize val
    node = Node.new(val)
    @head = node
    @tail = node
    node.next = node
    node.prev = node
  end

  def add node, val
    new_node = Node.new(val,node.next, node)
    node.next.prev = new_node
    node.next = new_node

    if node == @tail
      @tail = new_node
    end
    new_node
  end

  def remove node
    prev, n = node.prev, node.next
    prev.next = n
    n.prev = prev

    if node == @head
      @head = node.next
    end
    node
  end

  def output
    n = @head
    loop do
      print(n.val.to_s+" ")
      break if n.next == @head
      n = n.next
    end
    puts ""
  end
end

players = Array.new(input[0],0)
marbs = LinkedList.new 0
marbs.add marbs.head, 1
player_index = 2
current_node = marbs.add(marbs.head, 2)

3.upto(input[1]) do |m|

  if m % 23 == 0
    players[player_index] += m
    7.times {current_node = current_node.prev}

    players[player_index] += current_node.val

    current_node = marbs.remove(current_node).next
  else

    current_node = current_node.next 
    current_node = marbs.add current_node, m
  end

  #print "[#{player_index}] "
  #marbs.output

  player_index+=1
  player_index = 0 if player_index >= players.count
end

puts players.max
