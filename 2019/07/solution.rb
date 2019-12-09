input = File.open("input").read.chomp.split(",").map(&:to_i)

class Intcode
  attr_accessor :input, :output

  def setup_machine
    @position = ->(arr,i){ arr[arr[i]] }
    @immediate = ->(arr,i){ arr[i] }

    @modes = {
      0 => @position,
      1 => @immediate
    }

    @opcodes = {
      1 => ->(arr, i,mode){  arr[arr[i+3]] = mode[0].(arr,i+1) + mode[1].(arr,i+2); 4},
      2 => ->(arr, i,mode){  arr[arr[i+3]] = mode[0].(arr,i+1) * mode[1].(arr,i+2); 4},
      3 => ->(arr, i,mode){  arr[arr[i+1]] = @input.pop; 2},
      4 => ->(arr, i,mode){  @output.push(mode[0].(arr, i+1 )); 2},
      5 => ->(arr, i,mode){ mode[0].(arr, i+1) != 0 ? mode[1].(arr, i+2) - i : 3 },
      6 => ->(arr, i,mode){ mode[0].(arr, i+1) == 0 ? mode[1].(arr, i+2) - i : 3 },
      7 => ->(arr, i,mode){ arr[arr[i+3]] = (mode[0].(arr, i+1) < mode[1].(arr, i+2)  ? 1 : 0); 4 },
      8 => ->(arr, i,mode){ arr[arr[i+3]] = (mode[0].(arr, i+1) == mode[1].(arr, i+2)  ? 1 : 0); 4 },
      99 => ->(arr, i, _){ @exit = true; 1 }
    }
  end

  def initialize code
    @code = code
    reset
  end

  def finished?
    @exit
  end

  def reset
    @input = []
    @output = []
    @exit = false

    setup_machine
    @ip = 0
  end


  def get_modes value
    modes = (value / 100).to_s.chars

    loop do
      if modes.size < 3
        modes.unshift "0"
      else
        break
      end
    end

    modes.reverse.map {|f| @modes[f.to_i]}
  end

  def run

    loop do
      value = @code[@ip]

      opcode = value % 100
      func = @opcodes[opcode]

      modes = get_modes(value)
      ip_inc = func.(@code, @ip, modes)

      @ip += ip_inc
      break if @exit || @output.size > 0
    end

    @code[0]
  end
end

codes = (0..4).to_a.permutation.to_a

machine = Intcode.new input.clone

results = codes.map do |code|
  code.inject(0) do |inp2, inp|
    machine.reset

    machine.input << inp2
    machine.input << inp

    machine.run 

    machine.output.first
  end

  machine.output.first
end

puts results.max

codes = (5..9).to_a.permutation.to_a.map do |code|
  machines = code.map { |c| m = Intcode.new(input.clone) ; m.input << c; m}

  v = 0
  loop do
    break if machines.all? {|m| m.finished?}

    machines.each_with_index do |m, i|
      continue if m.finished?
      
      m.input.unshift v
      m.run

      v = m.output.pop unless m.output.empty?
    end

  end

  v
end

puts codes.max
