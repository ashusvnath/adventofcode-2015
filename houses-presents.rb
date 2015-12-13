filename = ARGV[0]
puts filename
filename ||= "houses-presents-input.txt"
lines = File.readlines(filename)
floor = 0
count = 0
visited_houses = Hash.new(0)
x = 0
y = 0

current_visited = "x:#{x}, y:#{y}"
visited_houses[current_visited]+=1
puts "startging at #{current_visited}"

lines[0].chars.each do |char| 
	case char
		when '^' 
			y += 1
		when 'v' 
			y -= 1
		when '>' 
			x += 1
		when '<' 
			x -= 1
	end
	current_visited = "x:#{x}, y:#{y}"
	puts "#{char} visiting #{current_visited}"
	visited_houses[current_visited]+=1
end
puts visited_houses.values.length
