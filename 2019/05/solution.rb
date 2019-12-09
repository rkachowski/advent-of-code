require 'pry-byebug'
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

  def initialize
    reset
  end

  def reset
    @input = []
    @output = []
    @exit = false

    setup_machine
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

  def run code, inval
    @input.push inval
    position = 0

    loop do
      value = code[position]

      opcode = value % 100
      func = @opcodes[opcode]

      modes = get_modes(value)
      ip_inc = func.(code, position, modes)

      break if @exit
      position += ip_inc
    end

    code[0]
    puts @output.inspect
  end
end

machine = Intcode.new
machine.run input.clone, 1

machine.reset
machine.run input.clone, 5
