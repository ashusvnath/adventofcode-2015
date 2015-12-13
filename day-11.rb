input = ARGV[0] || "hepxcrrq"

class String
	def next
		return self if /[^a-z]/.match(self)
		t = self.reverse.chars.to_a
		shift_next = true
		result = []
		while shift_next
			c = t.shift
			c = c.next_char
			result << c
			shift_next = (c == 'a')
		end
		result = (result+t).reverse.join
		result
	end

	def next_char
		return self if self.length > 1
		v = (((self.ord - 'a'.ord) + 1) % 26 + 'a'.ord).chr
		['i','o','l'].include?(v) ? v.next_char : v
	end
end

exit 1 if /[^a-z]/.match(input)

def cons3(str, debug = false)
	check = []
	arr = str.chars.to_a
	arr[0..-2].each_with_index{|c, idx|
		check << ((arr[idx+1].ord - c.ord == 1) ? '1' : '0')
	}
	result = check.join
	puts "cons3 #{result}" if debug
	/11/ =~ result
end

def doubltwice(str, debug = false)
	check = []
	arr = str.chars.to_a
	arr[0..-2].each_with_index{|c, idx|
		check << ((arr[idx+1].ord - c.ord == 0) ? '1' : '0')
	}
	result = check.join
	puts "doubltwice #{result}" if debug
	/10+1/ =~ result
end

def valid(str)
	cons3(str) && doubltwice(str)
end

count = 0
while !valid(input)
	count += 1
	input = input.next
	print "." if count % 1000 == 0
end
puts input