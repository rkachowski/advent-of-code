input = File.open("input").read.lines.map{|l| l.split(" ")}

class Coprocessor
  def initialize program
    @program = program
    @a = 0
    @b = 0
    @c = 0
    @d = 0
    @e = 0
    @f = 0
    @g = 0
    @h = 0

    @ic = 0

    @mul_count = 0
  end

  def set r, v
    instance_variable_set :"@#{r}", get_value(v)
    @ic += 1
  end

  def mul r, v
    instance_variable_set :"@#{r}", get_value(v) * get_value(r)
    @ic += 1
    @mul_count += 1
  end

  def sub r, v
    instance_variable_set :"@#{r}", get_value(r) - get_value(v)
    @ic += 1
  end

  def jnz r, v
    if get_value(r) != 0
      @ic += get_value(v)
    else
      @ic += 1
    end
  end

  def run
    loop do
      self.send @program[@ic][0],  *@program[@ic][1..]

      if (@ic >= (@program.size - 1)) then
        puts "end encountered - #{@mul_count} muls"
        exit
      end
    end
  end

  def get_value v
    if v =~ /\d/
      v.to_i
    else
      self.instance_variable_get("@"+v)
    end
  end
end

p = Coprocessor.new input

p.run
