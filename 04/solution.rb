require 'date'

input = File.open("input").read.lines
parsed = input.map do |s|
  date, rest = s.scan(/(\[.*\]) (.*)/).flatten
  {date: DateTime.parse(date), msg: rest}
end

sorted = parsed.sort {|a,b| a[:date] <=> b[:date]}

times = sorted.inject([]) do |acc,m|

  case m[:msg]
  when /Guard #(\d+) begins shift/
    acc << {id: $1.to_i}
  when /falls asleep/
    acc.last[:sleep] = m[:date]
  when /wakes up/
    sleep = acc.last.delete :sleep
    wake = m[:date]
    acc.last[:sleeps] ||= []
    acc.last[:sleeps] << (sleep.minute...wake.minute)
  end

  acc.last[:date] = m[:date].to_date
  acc
end

guard_sleep_times = times.group_by {|c| c[:id]}
total_sleeping = guard_sleep_times.transform_values do |entries|
  entries.map{|e| e[:sleeps]}.flatten.compact.reduce(0) { |sum, range| sum + range.size }
end

laziest_bastard = total_sleeping.key(total_sleeping.values.max)
minutes_asleep = guard_sleep_times[laziest_bastard].map{ |e| e[:sleeps].map(&:to_a)}
  .flatten.each_with_object(Hash.new(0)){|m,t| t[m] += 1}

puts minutes_asleep.key(minutes_asleep.values.max) * laziest_bastard
