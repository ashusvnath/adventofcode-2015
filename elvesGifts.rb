lines = File.readlines("elvesGifts.txt")
area = lines.inject(0) do |total_area, line|
	l,w,h = line.split('x').map(&:to_i).sort
	total_area += (2*l*w + 2*w*h + 2*h*l + l*w)
end
puts "Area: #{area}" 
length = lines.inject(0) do |total_length, line|
	l,w,h = line.split('x').map(&:to_i).sort
	total_length += (2*(l+w) + (l*w*h))
end
puts "Length: #{length}"
