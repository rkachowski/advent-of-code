input = 145852..616942

seq = ->(arr,i){ i < arr.size - 1 and arr[i+1] == arr[i] }
not_dec = ->(arr,i){ i == arr.size - 1 or arr[i+1] >= arr[i]}
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
  (digits.each_with_index.any? {|_, n| seq.(digits, n)}) and (digits.each_with_index.all? {|_,n| not_dec.(digits, n)})
}
valid2 = ->(num) {
  digits = num.digits.reverse
  not3.(digits)  and (digits.each_with_index.all? {|_,n| not_dec.(digits, n)})
}


puts input.each.count {|n| valid1.(n)}
puts input.each.count {|n| valid2.(n)}
