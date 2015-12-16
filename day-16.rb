filename = ARGV[0] || "day-16-input.txt"
is_exact = ARGV[1]

@mfcsa_results =  {
	children: 3,
	cats: 7,
	samoyeds: 2,
	pomeranians: 3,
	akitas: 0,
	vizslas: 0,
	goldfish: 5,
	trees: 3,
	cars: 2,
	perfumes: 1
}


line_patt = /^(?<name>Sue \d+):(?<properties>.*)$/
properties_patt = /(\w+): (\d+)/
aunts = {}
min_distance = 1.0/0.0
min_distance_aunt = nil

@mcfsa_upper_bound_keys = [:pomeranians, :goldfish]
@mcfsa_lower_bound_keys = [:cats, :tree]

def get_simple_distance(props)
	distance_sq = 0
	props.each_pair{|key, value|
		d = @mfcsa_results[key] - value
		distance_sq += (d*d)
	}
	return Math.sqrt(distance_sq)
end

def get_funny_distance(props)
	distance_sq = 0
	(props.keys & @mcfsa_upper_bound_keys).each { |key|
		d = props[key] - @mfcsa_results[key]
		if(d > 0)
			distance_sq += (d*d)
		end
	}

	(props.keys & @mcfsa_lower_bound_keys).each { |key|
		d = @mfcsa_results[key] - props[key]
		if(d > 0)
			distance_sq += (d*d)
		end
	}

	(props.keys - @mcfsa_upper_bound_keys - @mcfsa_lower_bound_keys).each { |key|
		d = (props[key] - @mfcsa_results[key])
		distance_sq += (d*d)
	}
	return Math.sqrt(distance_sq)
end

puts min_distance
File.readlines(filename).each do |line|
	result = line_patt.match(line)
	name = result["name"]
	props = Hash[result["properties"].scan(properties_patt).map{|pair| [pair[0].to_sym, pair[1].to_i]}]
	aunts[name] = props
	distance = is_exact ? get_funny_distance(props) : get_simple_distance(props)

	if(min_distance > distance)
		puts "#{name} #{distance} #{props}"
		min_distance = distance
		min_distance_aunt = name
	end
end

puts "#{min_distance_aunt} #{aunts[min_distance_aunt]}"