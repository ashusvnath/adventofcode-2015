require './day-19-helper'
filename = ARGV[0] || "day-19-test-input.txt"
generate = ARGV[1] || "generated"
start = ''
productions = {}
reductions = {}
patt = /(?<from>\w+) => (?<to>\w+)/

File.readlines(filename).each do |line|
	match = patt.match(line)
	if match
		from = match["from"]
		to = match["to"]
		productions[from] ||= []
		productions[from] << match["to"]
	else
		start = line.chomp
	end
end

puts "Production: #{productions}\n\nStart:#{start}\n\n"

program = Day19.new(productions, start)

results = program.results
puts "Count distinct productions starting with 'Start' : #{results.count}"
puts "Smallest production length #{program.smallest_production_length_by_reduction}"
