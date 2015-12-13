require "json"

filename = ARGV[0]
filename ||= "circuit-input.txt"

@circuit = { }

@commands = {
	LSHIFT: Proc.new{|num, rot|
		num << rot
	},
	RSHIFT: Proc.new{|num, rot|
		num >> rot
	},
	AND: Proc.new{|l, r|
		l & r
	},
	OR: Proc.new{|l, r|
		l | r
	},
	NOT: Proc.new{|v|
		0xFFFF ^ v
	},
}

def parse(v)
	if v.nil?
		v
	elsif /[a-z]+/.match(v)
		v.to_sym
	elsif /[0-9]+/.match(v)
		v.to_i
	end
end

def evaluate(ans)
	if ans.is_a? Fixnum
			puts "> #{ans}"
			return ans
	elsif ans.is_a? Array
			first = ans.first
			if @commands[first]
				puts "& #{ans}"
				op = @commands[first]
				return op.call(*ans[1..-1].map{|a| evaluate(a)})
			else
				v = ans.last
				puts "= #{first} #{v}"
				@circuit[first] = v
				return v
			end
	elsif ans.is_a? Symbol
			puts ">> #{ans}"
			@circuit[ans] = evaluate(@circuit[ans])
			return @circuit[ans]
	else
			puts "Unknown condition reached"
			exit -1
	end
end

command_pattern = /(?<expr>.*)(\s+)?->(\s+)?(?<var>\w+)/
expr_pattern = /((?<l>([a-z]+|\d+))(\s+))?((?<op>NOT|OR|AND|LSHIFT|RSHIFT)(\s+))?(?<r>([a-z]+|\d+))/
File.readlines(filename).each do |line| 
	command_match = command_pattern.match(line)
 	expr_match = expr_pattern.match(command_match["expr"])
	var = command_match["var"].to_sym
	op = expr_match["op"]
	l = expr_match["l"]
	r = expr_match["r"]
	@circuit[var] = op ? [op.to_sym, parse(l), parse(r)].compact : parse(r)
end

#puts JSON.pretty_generate(@circuit)

puts evaluate(:a)

