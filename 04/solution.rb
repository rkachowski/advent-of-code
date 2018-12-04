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

minutes_asleep = guard_sleep_times.transform_values do |entries|
  sleep_times = entries.map {|e| e[:sleeps]}.flatten.compact
  all_minutes = sleep_times.map(&:to_a).flatten
  all_minutes.each_with_object(Hash.new(0)){|m,t| t[m] += 1}
end

puts minutes_asleep[laziest_bastard].key(minutes_asleep[laziest_bastard].values.max) * laziest_bastard

id, _, sleeping_minute = minutes_asleep.inject([0,0,0]) { |(max_id, max_count, minute), (id,minute_map)|  
  if !minute_map.empty? && minute_map.values.max > max_count
    max_count = minute_map.values.max
    max_id = id
    minute = minute_map.key(max_count)
  end

  [max_id, max_count,minute]
}

puts id * sleeping_minute
