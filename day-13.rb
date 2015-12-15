require 'set'

inputfile = ARGV[0] || "day-13-input.txt"
ambivalent_person = ARGV[1]

change_mat = {}
pat = /(?<person>\w+) would (?<sign>gain|lose) (?<cost>\d+) happiness units by sitting next to (?<neighbour>\w+)\./
people = Set.new

File.readlines(inputfile).each do |line|
	match = pat.match(line)
	if match
		person = match['person']
		sign = match['sign'] == "gain" ? "" : "-"
		cost = match['cost']
		neighbour = match['neighbour']
		change = "#{sign}#{cost}".to_i
		change_mat[person] ||= {}
		change_mat[person][neighbour] = change
		people << person
		person << neighbour
	end
end

if ambivalent_person
	change_mat[ambivalent_person] = {}
	people.each{ |person|
		change_mat[person][ambivalent_person] = 0
		change_mat[ambivalent_person][person] = 0
	}
	people << ambivalent_person
end

def process(queue, change_mat, people)
	results = {}
	highest_total_change = 0
	corresponding_arrangement = []
	while queue.length > 0
		#print "-"
		current_order = queue.shift
		if current_order.length == people.length
			total_change = 0
			current_order << current_order[0]
			#puts "#{current_order}"
			total_change = current_order.each_cons(2).map{|pair| p1 = pair[0]; p2 = pair[1]; change_mat[p1][p2] + change_mat[p2][p1]}.inject{|a,v| a+v}
			results[current_order] = total_change
			if total_change > highest_total_change
				#print "."
				highest_total_change = total_change
				corresponding_arrangement = current_order
			end
		else
			(people - current_order).each{|person|
				queue << (current_order + [person])
			}
		end
	end
	#puts "\n#{results}"
	return [highest_total_change, corresponding_arrangement]
end

result = process(people.map{|p| [p]}, change_mat, people)

puts "\n#{result}"