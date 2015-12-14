filename = ARGV[0] || "day-12-input.txt"
File.readlines(filename).each { |line|
	cleaned_line = line.gsub(/{[^{]*(?>"red":|:"red")[^}]*}/, "")
	puts line.scan(/-?\d+/).map(&:to_i).inject(0){|a,v| a+v}
	puts cleaned_line.scan(/-?\d+/).map(&:to_i).inject(0){|a,v| a+v}
}