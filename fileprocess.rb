lines = File.readlines("file.txt")
floor = 0
count = 0
lines[0].chars.map do |char| 
	count += 1
	case char
		when '(' 
			floor += 1
		when ')' 
			floor -= 1
	end
	puts count if floor == -1
	floor
end
