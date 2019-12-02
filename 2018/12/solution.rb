input = File.open("input").read.lines
$initial_state = input.shift.split(": ").last.chomp.chars
input.shift 
$state_map = input.each_with_object(Hash.new(".")) {|l,h| pat,result = l.split(" => "); h[pat] = result.chomp}


state = Array.new($initial_state.size*10,".")
state.insert(state.size/2,$initial_state)
state.flatten!

def iterate state
  state.size.times.map do |i|
    next "." if i < 2
    pat = (i-2..i+2).each.map {|index| state[index % state.size]}.join
    $state_map[pat]
  end
end

def score state
  state.size.times.inject(0) do |sum,i|
    if state[i] == "#"
      sum + i-(state.size-$initial_state.size)/2
    else 
      sum
    end
  end
end
3000.times.inject(state) do |s,i| 
  state = iterate(s)
  puts "#{ i+1} - #{score(state)}"
  state
end

f = ->(i){5011 + 26 * (i - 167) }
puts f.call(50000000000)

