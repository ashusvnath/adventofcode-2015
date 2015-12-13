require 'set'
require 'json'

filename = ARGV[0]
filename ||= "day-9-input.txt"

metric = ARGV[1]
metric ||= "shortest"

path_regex = /(?<from>\w+)(\s+)to(\s+)(?<to>\w+)(\s+)=(\s+)(?<d>\d+)/

@edges = {}
locations = Set.new()

File.readlines(filename).each do |line|
	matched_values = path_regex.match(line)
	
	from = matched_values['from']
	to =  matched_values['to']
	edge = [from, to].sort
	d = matched_values['d'].to_i
	@edges[edge] = d

	locations << from
	locations << to

end

def find_closest(from, visited)
	val = @edges.inject(['blank', 9999]){|acc, edge|
		#puts "#{acc.join(':')} #{edge.join('->')}"
		
		if edge[0].include?(from) 
			other = (edge[0]-[from]).first
			(!visited.include?(other) && acc[1] > edge[1]) ? [other, edge[1]] : acc
		else
			acc
		end
	}
	#puts val #.map{|v| puts "#{v} #{v.class}"}
	val
end

def find_longest_for_length(queue, length)
	final = []
	paths_count = 0
	iterations_count = 0
	while queue.length != 0
		iterations_count += 1
		vis = queue.shift
		if vis[0].length == length
			#puts "Found full_path : #{vis}"
			final << vis
		else
			@edges.each{|leg, cost|
				last_vertex = vis[0].last
				other = (leg-[last_vertex]).first
				if leg.include?(last_vertex) && !vis[0].include?(other)
					paths_count += 1
					queue << [vis[0] + [other], vis[1] + cost]
				end
			}
		end
	end
	puts "paths_count : #{paths_count}, iterations_count: #{iterations_count}"
	return final.inject([[], 0]){|acc, path_cost|
		path_cost[1] > acc[1] ? path_cost : acc
	}
end

def find_shortest_path(from)
	#puts from
	visited = [from]
	distance = 0
	while true
		next_location, d = find_closest(from, visited)
		if(visited.include?(next_location) || next_location == "blank")
			#puts ".."
			return [visited, distance]
		end
		distance += d
		visited << next_location
		from = next_location
	end
end


start = Time.now
if metric == 'shortest'
	#puts "#{locations.to_a.join(' ')}"
	result = locations.inject([]){|acc, location| 
		current = find_shortest_path(location)
		if acc.length == 0
			current
		elsif acc[1] > current[1]
			current
		else
			acc
		end
	}

	puts "Shortest Path: #{result}"
elsif metric == "longest"
	result = find_longest_for_length(locations.map{|l| [[l], 0]}, locations.length)
	puts "Longest Path: #{result}"
end
total_time = Time.now - start
puts "Time Taken: #{total_time}"
