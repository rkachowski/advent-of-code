require 'pry-byebug'
require 'set'

input = File.open("input").read.chomp.split(",").map(&:to_i)

class Code < Array
  def [](key)
    self[key] = 0 if key > (self.size - 1)

    super || 0
  end
end

class Intcode
  attr_accessor :input, :output, :relative_base, :break_on_output

  def setup_machine
    @relative_base = 0

    @position = ->(arr,i,w=false){ w ? arr[i] : arr[arr[i]] }
    @immediate = ->(arr,i,_=false){ arr[i] }
    @relative = ->(arr,i, w=false){ w ? arr[i] + @relative_base :  arr[arr[i]+ @relative_base] }

    @modes = {
      0 => @position,
      1 => @immediate,
      2 => @relative
    }

    @opcodes = {
      1 => ->(arr, i,mode){  arr[mode[2].(arr, i+3,true)] = mode[0].(arr,i+1) + mode[1].(arr,i+2); 4},
      2 => ->(arr, i,mode){  arr[mode[2].(arr, i+3,true)] = mode[0].(arr,i+1) * mode[1].(arr,i+2); 4},
      3 => ->(arr, i,mode){  arr[mode[0].(arr, i+1,true)] = @input.pop; 2},
      4 => ->(arr, i,mode){  @output.push(mode[0].(arr, i+1 )); 2},
      5 => ->(arr, i,mode){ mode[0].(arr, i+1) != 0 ? mode[1].(arr, i+2) - i : 3 },
      6 => ->(arr, i,mode){ mode[0].(arr, i+1) == 0 ? mode[1].(arr, i+2) - i : 3 },
      7 => ->(arr, i,mode){ arr[mode[2].(arr, i+3,true)] = (mode[0].(arr, i+1) < mode[1].(arr, i+2)  ? 1 : 0); 4 },
      8 => ->(arr, i,mode){ arr[mode[2].(arr, i+3,true)] = (mode[0].(arr, i+1) == mode[1].(arr, i+2)  ? 1 : 0); 4 },
      9 => ->(arr, i,mode){ @relative_base += mode[0].(arr, i+1) ; 2},

      99 => ->(arr, i, _){ @exit = true; 1 }
    }
  end

  def initialize code
    @code = Code.new 0, 0
    @code.concat code
    reset
    @break_on_output = false
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
      break if @exit
      break if @break_on_output and @output.size > 0
    end
  end
end


m = Intcode.new input
m.input << 1
m.break_on_output = true

directions = [
  [0,1],
  [-1,0],
  [0,-1],
  [1,0]
]

current_position = [0,0]
current_direction = 0

white_coords = Set.new
black_coords = Set.new

output = []
loop do
  m.run

  unless m.finished?
    output << m.output.pop

    if output.size == 2
      color, direction = output

      [black_coords,white_coords].each {|s| s.delete? current_position }

      if color == 0
        black_coords << current_position.clone
      else
        white_coords << current_position.clone
      end


      if direction == 0
        current_direction += 1
        current_direction %= 4
      else
        current_direction -= 1
        current_direction = 3 if current_direction < 0
      end

      current_position[0] += directions[current_direction][0]
      current_position[1] += directions[current_direction][1]

      if white_coords.include? current_position
        m.input << 1
      else 
        m.input << 0
      end

      output = []
    end
  end

  break if m.finished?
end


#puts (white_coords | black_coords).size

x_extents = white_coords.map {|s| s[0] }.minmax
y_extents = white_coords.map {|s| s[1] }.minmax

y_extents[1].downto(y_extents[0]) do |y|
  x_extents[0].upto(x_extents[1]) do |x|
    if white_coords.member? [x,y]
      print "#"
    else
      print "."
    end
  end
  puts ""
end
