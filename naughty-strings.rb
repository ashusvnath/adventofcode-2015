filename = ARGV[0]
filename ||= "naughty-strings-input.txt"
lines = File.readlines(filename)

contains_3_vowels = /([aeiou][^aeiou]*){3}/

def repeat_regex
	@repeat_regex_string ||= "bcdefghijklmnopqrstuvwxyz".chars.inject("aa") { |acc, char| 
		acc += "|#{char}#{char}"
	}
	return /#{@repeat_regex_string}/
end

forbidden_regex = /(ab|cd|pq|xy)/

nice_strings = lines.inject(0) do |acc, line|
	acc += ( (!line.match(forbidden_regex) && line.match(contains_3_vowels) && line.match(repeat_regex)) ? 1 : 0 )
=begin
	puts "has 3 vowels" if line.match(contains_3_vowels)
	puts "has at at least one repeated alphabet" if line.match(repeat_regex)
	puts "has forbidden regex" if 
=end
end
puts nice_strings
