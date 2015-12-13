filename = ARGV[0]
filename ||= "day-8-input.txt"

total_code_length = 0
total_memory_length = 0

File.readlines(filename).each do |input_line|
	line = input_line.chomp
	puts "#{line.chars.to_a.join(' ')} #{line.length} #{eval(line).length}"
	total_code_length += line.length
	total_memory_length += eval(line).length
end

puts total_code_length - total_memory_length