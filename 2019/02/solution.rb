input = File.open("input").read.split(",").map(&:to_i)

@opcodes = {
  1 => ->(arr, i){  arr[arr[i+3]] = arr[arr[i+1]] + arr[arr[i+2]] },
  2 => ->(arr, i){  arr[arr[i+3]] = arr[arr[i+1]] * arr[arr[i+2]] },
  99 => ->(arr, i){ "noop" },
}

def run inp
  position = 0

  loop do
    value = inp[position]
    @opcodes[value].(inp,position)

    break if value == 99
    position += 4
  end

  inp[0]
end

part1 = input.clone
part1[1] = 12
part1[2] = 2
puts run(part1)

(0..99).each do |noun|
  (0..99).each do |verb|
    part2 = input.clone
    part2[1] = noun
    part2[2] = verb
    result = run(part2)

    if result == 19690720
      puts noun * 100 + verb
      exit
    end
  end
end
