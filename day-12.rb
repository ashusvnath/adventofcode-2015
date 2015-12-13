filename = ARGV[0] || "day-12-input.txt"
File.readlines(filename).each { |line|
	puts line.scan(/-?\d+/).map(&:to_i).inject(0){|a,v| a+v}
}