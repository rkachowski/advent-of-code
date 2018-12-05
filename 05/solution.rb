input = File.open("input").read.chomp

def process(str)
  match = ->(a,b){ a == b.swapcase or b == a.swapcase }
  chars = str.dup.chars.to_a
  i = 0

  loop do
      break if i >= chars.size-1
      if match.call(chars[i],chars[i+1])
        chars.delete_at(i)
        chars.delete_at(i)
        i -= 1
      else
        i += 1
      end
  end

  chars.join
end

def step_1(str)
  input = str.dup
  process(input).size
end

def step_2(str)
  input = str.dup
  map = ('a'..'z').to_a.each_with_object({}) do |c, result|
    result[c] = process(input.gsub(/#{c}/i,"")).size
  end
  map.values.min
end

puts step_1(input)
puts step_2(input)
