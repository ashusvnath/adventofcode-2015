@filename = ARGV[0] || "day-17-input.txt"
@total_eggnog = (ARGV[1] || "150").to_i

@containers = []
queue = []

valid_combinations = Hash.new(0)

File.readlines(@filename).each do |line|
	@containers << line.to_i
end

idx = 1
total_iterations = (2 ** @containers.length)
min_containers = @containers.length

while idx < total_iterations
	t = idx

	count = 0
	sum = 0
	used = 0
	while t > 0
		if t&1 != 0
			sum += @containers[count]
		end
		t >>= 1
		count += 1
	end

	if sum == @total_eggnog
		valid_combinations[idx.to_s(2).chars.count("1")] += 1
	end
	idx += 1
	print "." if idx % 100000 == 0
end

puts "\nContainers: #{@containers}"
puts "Combination(size=>count): #{valid_combinations}"
puts "Number of combinations: #{valid_combinations.values.inject(&:+)}"
