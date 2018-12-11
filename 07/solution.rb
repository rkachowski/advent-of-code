input = File.open("input").read.lines
input.map! { |l| f = l.match /(\b[A-Z]\b).*(\b[A-Z]\b)/ ; [f[1],f[2]]}

dep_map = input.each_with_object({}) do |(dep, st),hsh|
  hsh[st] ||= []
  hsh[st] << dep
end
input.flatten.uniq.each { |f| dep_map[f] ||= [] }
satisfied = []

step_1 = Marshal.load(Marshal.dump(dep_map))
loop do
  break if step_1.empty?

  curr = step_1.select { |step, deps| deps.empty? }.keys.sort.first
  step_1.delete(curr)
  step_1.transform_values! {|deps| deps.delete(curr);deps}

  satisfied << curr
end
puts satisfied.join

workers = []
5.times.map { workers << {task:nil,cost: 0 } }
cost = ("A".."Z").to_a
step_2 = dep_map.map { |(k, v)| hsh = {}; hsh[:cost] =  cost.index(k) + 61; hsh[:deps] = v; hsh[:name] = k;hsh}

ticks = 0
loop do
  loop do
    available = workers.select {|v| v[:task] == nil}
    break if available.empty?

    task = step_2.select { |step| step[:deps].empty? }.sort{|f,g| f[:name] <=> g[:name] }.first
    break unless task

    step_2.delete(task)
    available.first[:cost] = task[:cost]
    available.first[:task] = task[:name]
  end

  ticks += 1

  workers.map! do |v| 
    if v[:task]
      v[:cost] -= 1

      if v[:cost] == 0
        step_2.map! {|val| val[:deps].delete(v[:task]);val}
        v[:task] = nil
      end
    end
    v
  end

  if step_2.empty? and workers.map{|f| f[:cost]}.uniq.first == 0
    break
  end
end

puts ticks
