require 'levenshtein'

input = File.open("input").read.lines.map(&:chomp)

char_counts = input.map do |id|
  id.chars.inject(Hash.new(0)) { |hsh, c| hsh[c] += 1 ;hsh}
end

puts char_counts.select{|h| h.values.include? 2}.count * char_counts.select{|h| h.values.include? 3}.count

input.each do |id|
  to_test = Marshal.load(Marshal.dump(input))
  to_test.delete id
  to_test.each do |id2|
    if Levenshtein.distance(id,id2) == 1
      puts "found #{id} #{id2}"
      id.chars.each_with_index do |c,i| 
        if id2.chars[i] != c
          chars = id2.chars
          chars.delete_at i
          puts chars.join

          exit
        end
      end
    end
  end
end
