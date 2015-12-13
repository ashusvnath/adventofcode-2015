filename = ARGV[0]
filename ||= "day-8-input.txt"

total_code_length = 0
total_encoded_length = 0

File.readlines(filename).each do |input_line|
	line = input_line.chomp
	total_code_length += line.length
	encoded_string = '"' + line.gsub(/\\/,'\&\&').gsub(/"/, "\\\"") + '"'
	#interesting note: ruby gsub(/\\/, "\\\\") will not give you what you want
	total_encoded_length += encoded_string.length
	puts "#{line.chars.to_a.join(' ')} #{line.length} -> #{encoded_string.chars.to_a.join(' ')}  #{encoded_string.length}"
end

puts total_encoded_length - total_code_length