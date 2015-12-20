require 'set'

class Array
	def custom_replace(first, last, new_string)
		((first)..(last)).each{self.delete_at(first)}
		self.insert(first, new_string)
		self
	end
end

class String
	def replace_at(first, last, value)
		as_array = self.split('')
		as_array.custom_replace(first, last, value)
		as_array.join
	end

	def get_all_indices(string)
		results = []
		offset = 0
		while !(match = self.index(string, offset)).nil?
			results << match
			yield match if block_given?
			offset = (match + 1)
		end
		results
	end
end

class Day19
	def initialize(productions, start)
		@productions = productions
		@start = start
		@seen_bad = Set.new
		generate_reductions
	end

	def generate_reductions
		@reductions = @productions.inject({})do |result, (key, values)|
			values.each{|value|
				result.merge!({value => key}) if !value.start_with?("CRn") && key != "e"
			}
			result
		end
	end

	def results
		@productions.inject(Set.new) do |result, (replace_key, replace_values)|
			offset = 0
			@start.get_all_indices(replace_key) do |match_index|
				replace_values.each do |replace_value|
					produced = @start.replace_at(match_index, match_index + replace_key.length - 1, replace_value)
					result << produced
				end
			end
			result
		end.to_a
	end

	def smallest_production_length
		queue = @productions["e"].map{|starting| [starting, 1]}
		count = 0
		found = false
		iter_count = 0
		while queue.length > 0 && !found
			starting, count = queue.shift
			Day19.new(@productions, starting).results.each do |result|
				if(result == @start)
					found = true
					break
				end
				queue.push([result, count+1]) if result.length < @start.length
			end
			iter_count += 1
			print "." if iter_count % 10000 == 0
		end
		count + 1
	end

	def smallest_production_length_by_reduction
		remaining_string = @start
		@count = 0
		replacement_iter_count = 0
		iter_count = 0
		found = false
		@pbcount = 0
		while !found
	 		print "*"
			remaining_string = @start
	 		@count = @pbcount
	 		iter_count = replacement_iter_count = 0
			r = Random.new
			while !(found = @productions["e"].include?(remaining_string))
				rk = @reductions.keys.shuffle(random: r).first
				idx = remaining_string.index(rk)
				print "(#{remaining_string.length})<#{rk}>" if iter_count % 10000 == 0
				if idx != nil
					remaining_string.gsub!(rk) do |m|
						if r.rand(1000) > 300
							@count += 1
							replacement_iter_count += 1
							retval = @reductions[rk]
							print "." 
						else
							retval = rk
						end
						retval
					end
				end
	 			iter_count += 1
	 			if (iter_count - replacement_iter_count) > 1000 #2*reduction_keys_by_length.length
					print "|Throwing away remaining_string:'#{remaining_string}'-" if remaining_string.length < 25
					print "l:#{remaining_string.length}-c:#{@count}-(ric:#{replacement_iter_count})>\n"
					break
	 			end
	 		end
	 	end
		@count += 1 if found
		return @count
	end
end