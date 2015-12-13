filename = ARGV[0]
puts filename
filename ||= "houses-presents-input.txt"
lines = File.readlines(filename)
floor = 0
count = 0
@visited_houses = Hash.new(0)
x = 0
y = 0

current_visited = "x:#{x}, y:#{y}"
@visited_houses[current_visited]+=1
puts "startging at #{current_visited}"

@santa = {name: :santa, x: 0, y: 0}
@robo = {name: :robo, x: 0, y:0}
@current_command_receiver = nil
def get_current_command_receiver
	@current_command_receiver ||= @robo
	@current_command_receiver = @current_command_receiver == @santa ? @robo : @santa
	return @current_command_receiver
end

def move_receiver_by_command_and_deliver_present(receiver, command)
	case command
		when '^' 
			receiver[:y] += 1
		when 'v' 
			receiver[:y] -= 1
		when '>' 
			receiver[:x] += 1
		when '<' 
			receiver[:x] -= 1
	end
	current_visited = "x:#{receiver[:x]}, y:#{receiver[:y]}"
	puts "receiver #{receiver} visiting #{current_visited} basedOn #{command}"
	@visited_houses[current_visited] += 1
end

lines[0].chars.each do |char| 
	move_receiver_by_command_and_deliver_present(get_current_command_receiver, char)
end
puts @visited_houses.values.length
