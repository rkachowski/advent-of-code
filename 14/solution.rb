elves = [0,1]

string = "37"

advance = ->() {
  score = elves.map{|i| string[i].to_i}.sum
  tens, rem = (score / 10) % 10, score % 10
  string << tens.to_s if tens > 0
  string << rem.to_s

  elves.map! { |i| (i+(string[i].to_i + 1)) % string.size}
}

t = 286051
(t+8).times do
  advance.call
end
puts string[t..t+9]

string = "37"
elves = [0,1]
t = "286051"

ticks = 0
loop do
  score = elves.reduce(0){|sum,i| sum + string[i].to_i}
  tens, rem = (score / 10) % 10, score % 10
  string << tens.to_s if tens > 0
  string << rem.to_s

  ticks += 1
  elves[0] = (elves[0]+(string[elves[0]].to_i + 1)) % string.size
  elves[1] = (elves[1]+(string[elves[1]].to_i + 1)) % string.size

  if string.slice(string.size - 6,6).include? t
    puts string.index t
    abort
  end
  puts ticks if ticks % 10000 == 0
end
