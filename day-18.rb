class Numeric
	def to_bits(size)
		self.to_s(2).rjust(size, "0").chars.map{|c| c.to_i}
	end
end

class Grid
	class << self
		attr_accessor :corners_on
	end

	def initialize(rows)
		@rows = rows
		(@rows[0][0] = @rows[-1][0] = @rows[0][-1] = @rows[-1][-1] = 1) if self.class.corners_on
		@num_rows = @rows.length
	end

	def next_iteration
		count = 0
		new_rows = @rows.inject([]){|acc, value|
			prev_row = ((count == 0) ? blank : @rows[count - 1])
			next_row = ((count == (@num_rows - 1)) ? blank : @rows[count + 1])
 			(count += 1)
 			acc << calculate([0] + prev_row + [0], [0] + value + [0], [0] + next_row + [0])
		}
		Grid.new(new_rows)
	end

	def to_s
		[
			"Now",
			"#{@rows.map{|element| element.map{|v| v == 1 ? "#" : "." }.join }.join("\n")}",
			"Total live cells #{self.total_live}\n\n"
		].join("\n")
	end

	def total_live
		@rows.inject(0){|acc, value| acc + value.inject(&:+)}
	end

	private
		def blank
			[0] * @num_rows
		end

		def calculate(prev_row, row, next_row)
			idx = 1
			row[1..-2].map { |element|
				result = 0
				live_count = 0
				live_count += (prev_row[idx-1] + prev_row[idx] + prev_row[idx+1])
				live_count += (next_row[idx-1] + next_row[idx] + next_row[idx+1])
				live_count += (row[idx-1] + row[idx+1])
				if (element == 1)
					result = ([2, 3].include?(live_count) ? 1 : 0)
				elsif (element == 0)
					result = ((live_count == 3) ? 1 : 0)
				end
				idx += 1
				result
			}
		end
end


filename = ARGV[0] || "day-18-input.txt"
Grid.corners_on = ARGV[1]

start_configuration = []

File.readlines(filename).each do |line|
	start_configuration << line.gsub(/\#/, '1').gsub(/\./, '0').chomp.split('').map(&:to_i)
end

grid = Grid.new(start_configuration)
#puts grid

start_configuration.length.times{|i| grid = grid.next_iteration; }# puts "Itreation #{i+1} #{grid}"; }
puts grid.total_live