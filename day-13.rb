require 'set'

inputfile = ARGV[0] || "day-13-input.txt"

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
puts "#{change_mat}"
puts "#{people.to_a}"
