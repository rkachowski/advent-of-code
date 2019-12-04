input = 145852..616942

seq = ->(digits){ digits.each_with_index.any? {|_,i| i < digits.size - 1 and digits[i+1] == digits[i] } }
ascending = ->(digits){digits.inject(0) { |p,d| return false if p > d; d }; true  }
not3 = ->(digits){
  acc = digits.each_with_index.inject({}) do |h,(d,i)|
    h[d] ||= 0
    h[d] += 1 if digits[i+1] == d
    h
  end

  acc.values.include?(1)
}

valid1 = ->(num) {
  digits = num.digits.reverse
  seq.(digits) and ascending.(digits)
}
valid2 = ->(num) {
  digits = num.digits.reverse
  not3.(digits)  and ascending.(digits)
}

puts input.each.count {|n| valid1.(n)}
puts input.each.count {|n| valid2.(n)}
