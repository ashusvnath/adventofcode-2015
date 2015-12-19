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
	def initialize(productions, start, reversals = nil)
		@productions = productions
		@start = start
		@reversals = reversals
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
		seen = Set.new
		termination_in_1_set = @productions["e"]
		termination_in_2_set = @productions.values
		@count = -1
		found = false


		puts "Dead end production values #{terminal_production_values}"
		queue = [[reduction_start = clean_reversals_make_start_string_for_reduction, 0]]
		puts "Reduction_start #{reduction_start}"
		puts "Reversals #{@reversals}"
		iter_count1 = 0

		while queue.length > 0 && !found
			#puts "#{queue[0]}"
			iter_count1 += 1
			start, c = queue.shift
			if termination_in_1_set.include?(start)
				found = true
				@count = c + 1
				break
			end
			if termination_in_2_set.include?(start)
				found = true
				@count = c + 2
				break
			end
			iter_count2 = 0
			@reversals.keys.each do |key|
				value = @reversals[key]
				#exit 0 if (iter_count>= 200)
				start.get_all_indices(key) do |idx|
					iter_count2 += 1
					print "|#{queue.length}->#{queue.last[0].length}->" if iter_count2 % 100 == 0
					reduced_string = start.replace_at(idx, idx + key.length - 1, value)

					#puts "Replacing #{key} at #{idx} with #{value} in \n#{start}\n to give\n#{reduced_string}\n\n"
					queue << [reduced_string, c + 1] if seen.add?(reduced_string) && reduced_string.length < start.length
				end
			end
			#exit 0 if (iter_count >= 200)
			print "|#{queue.length}->#{queue.last[0].length}.>" if iter_count1 % 100 == 0
		end
		return @count
	end

	private
		def terminal_production_values
			replacement_strings_by_length = @reversals.keys.sort_by(&:length).reverse

			dead_end_production_values = replacement_strings_by_length.take_while{|v| v.length > 2}.inject([]){|acc, v|
				acc << v if @productions.keys.find{|k| v.start_with?(k)} == nil
				acc
			}
			dead_end_production_values
		end

		def clean_reversals_make_start_string_for_reduction
			reduction_start = @start
			terminal_production_values.each{|patt|
				while /#{patt}/.match(reduction_start)
					reduction_start = reduction_start.gsub(patt, @reversals[patt])
				end
				@reversals.delete(patt)
			}
			reduction_start
		end
end