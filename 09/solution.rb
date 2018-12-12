input = [416, 71975*100]
#test = [10, 1618]
#test = [9, 25]

players = Array.new(input[0],0)
marbs = [0,1]

player_index = 1
current_index = 1

2.upto(input[1]) do |m|

  if m % 23 == 0
    players[player_index] += m
    current_index -= 7
    current_index = current_index % marbs.size if current_index < 0
    players[player_index] += marbs.delete_at(current_index)
  else

    current_index = (current_index + 2)
    current_index = current_index % marbs.size if current_index > marbs.size
    
    marbs.insert(current_index, m)
  end

  #puts "[#{player_index+1}] #{marbs.join(" ")}"
  player_index+=1
  player_index = 0 if player_index >= players.count
end

puts players.max
