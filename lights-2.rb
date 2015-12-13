filename = ARGV[0]
filename ||= "lights-input.txt"

lights = (0..999).map{(0..999).map{0}}

commands = {
	"toggle" => Proc.new { |x1, y1, x2, y2|
		(x1..x2).each{|x| (y1..y2).each{|y| lights[x][y] += 2 }}
	}, 
	"on" => Proc.new { |x1, y1, x2, y2|
		(x1..x2).each{|x| (y1..y2).each{|y| lights[x][y] += 1 }}
	},
	"off" => Proc.new { |x1, y1, x2, y2|
		(x1..x2).each{|x| (y1..y2).each{|y| lights[x][y] -= 1 if lights[x][y] > 0}}
	}
}

pattern = /(?<command>on|toggle|off)(\s+)?(?<x1>\d+),(\s+)?(?<y1>\d+)(\s+)?through(\s+)?(?<x2>\d+),(\s+)?(?<y2>\d+)/

File.readlines(filename).each do |line| 
	results = pattern.match(line) 
	if results != nil
		command = results["command"]
		commands[command].call(results["x1"].to_i, results["y1"].to_i, results["x2"].to_i, results["y2"].to_i)
	end
end

puts lights.inject(0){|val, row| row.inject(val) { |val, brightness| val + brightness }}
