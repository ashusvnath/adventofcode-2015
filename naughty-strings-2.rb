filename = ARGV[0]
filename ||= "naughty-strings-input.txt"
lines = File.readlines(filename)
@alphabets = "abcdefghijklmnopqrstuvwxyz"

def repeat_regex1
	@repeat_regex_1 ||= @alphabets.chars.inject([]){ |acc, char1| 
		acc + @alphabets.chars.map{|char2| 
			seq = "#{char1}#{char2}"
			part = "#{seq}.*#{seq}"
		}
		 
	}.join("|")
	return /#{@repeat_regex_1}/
end

def repeat_regex2
	@repeat_regex_2 ||= @alphabets.chars.drop(1).inject("a.a"){|acc, alphabet|	
		acc += "|#{alphabet}.#{alphabet}"
	}
	return /#{@repeat_regex_2}/
end

nice_strings = lines.inject(0) do |acc, line|
	acc += ( line.match(repeat_regex1) && line.match(repeat_regex2) ? 1 : 0 )
end
puts nice_strings
