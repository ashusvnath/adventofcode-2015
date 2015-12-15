filename = ARGV[0] || "day-14-input.txt"
MAX_TIME = (ARGV[1] || "2503").to_i
by_points = ARGV[2] == "by_points"

class Reindeer
	attr_reader :points, :distance, :name

	def initialize(name, speed, flytime, stoptime)
		@name = name
		@speed = speed
		@flytime = flytime
		@stoptime = stoptime

		@points = 0
		@distance = 0

		@burst_time = flytime
		@wait_time = 0
	end

	def move_timestep
		if @burst_time > 0
			@distance += @speed
			@burst_time -= 1
			@wait_time = @stoptime if @burst_time == 0
		elsif @wait_time > 0
			@wait_time -= 1
			@burst_time = @flytime if @wait_time == 0
		end
	end

	def incr_points
		@points += 1
	end
end

patt = /(?<reindeer>\w+) can fly (?<speed>\d+) km\/s for (?<flytime>\d+) seconds, but then must rest for (?<stoptime>\d+) seconds./


all_reindeer = []

File.readlines(filename).each { |line|
	result = patt.match(line)
	reindeer = result["reindeer"]
	speed = result["speed"].to_i
	flytime = result["flytime"].to_i
	stoptime = result["stoptime"].to_i
	all_reindeer << Reindeer.new(reindeer, speed, flytime, stoptime)
}


def lead_by_points
end

def lead_by_distance
end

1.upto(MAX_TIME) {
	lead_distance = 0
	lead_reindeer = []
	all_reindeer.each do |reindeer|
		reindeer.move_timestep
		if lead_distance < reindeer.distance
			lead_distance = reindeer.distance
			lead_reindeer = [reindeer]
		elsif lead_distance == reindeer.distance
			lead_reindeer << reindeer
		end
	end
	lead_reindeer.map(&:incr_points)
}

puts "After #{MAX_TIME} seconds, the standings are "
all_reindeer.map{|reindeer| puts "#{reindeer.name} points:#{reindeer.points} distance:#{reindeer.distance}"}

puts "And the winner is : " + all_reindeer.max_by{|reindeer| by_points ? reindeer.points : reindeer.distance}.name