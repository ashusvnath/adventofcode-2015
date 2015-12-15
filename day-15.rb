require 'matrix'

class Ingredient
	attr_reader :name, :properties

	def initialize(name, properties)
		@name = name
		@properties = properties
	end

	def to_s
		"#{@name} : #{@properties}"
	end
end


class Recipe
	class << self
		attr_accessor :scoring_properties
	end

	def initialize
		@recipe_mat_builder = []
		@coeff_values = []
		@calories = 0
	end

	def add(ingredient, teaspoon)
		ingredient_scoring_values = self.class.scoring_properties.map{|sp| ingredient.properties[sp]}
		@recipe_mat_builder << ingredient_scoring_values
		@coeff_values << teaspoon
		nil
	end

	def score
		recipe_mat = Matrix[*@recipe_mat_builder].transpose
		coeff_mat = Matrix[@coeff_values].transpose
		(recipe_mat * coeff_mat).to_a.flatten.inject(1){|a, v| a * (v < 0 ? 0 : v)}
	end
end


class RecipeIterator
	def initialize(total_teaspoons, ingredient_count)
		@total = total_teaspoons
		@total_bitsize = total_teaspoons.to_s(2).length
		@bit_mask  = ("1" * @total_bitsize).to_i(2)
		@max = (total_teaspoons << (ingredient_count - 1) * @total_bitsize) + 1
		@count = 0
	end

	def each(&block)
		raise "No block given!" if block == nil
		while has_next
			yield get_teaspoons
		end
	end

	private
		def get_teaspoons
			local_count = @count
			counts = []
			while local_count > 0
				counts << (local_count & @bit_mask)
				local_count >>= @total_bitsize
			end
			return counts
		end

		def has_next
			@count += 1
			while !(is_valid || done?)
				@count +=1
			end
			!done?
		end

		def is_valid
			get_teaspoons.inject(&:+) == @total
		end

		def done?
			@count >= @max
		end
end

filename = ARGV[0] || "day-15-input.txt"
@required_calories = (ARGV[1] || "0").to_i

ingredient_line = /^(?<name>\w+):(?<properties>(.*))$/
properites_segment = /(?<property>\w+)\s+(?<value>(\+|-)?\d+)/

@ingredients = {}

File.readlines(filename).each do |line|
	result = ingredient_line.match(line)
	name = result["name"]
	properties = result["properties"].scan(properites_segment).map{|p| p[1] = p[1].to_i; p}
	ingredient = Ingredient.new(name, Hash[properties])
	@ingredients[name] = ingredient
	#puts ingredient
end

TOTAL_TEASPOONS = 100
count = 1

@ingredient_names = @ingredients.keys

recipe_iterator = RecipeIterator.new(TOTAL_TEASPOONS, @ingredient_names.length)
scoring_properties = @ingredients.values[0].properties.keys - ["calories"]
Recipe.scoring_properties = scoring_properties

def should_skip?(teaspoon_counts)
	if @required_calories > 0 
		count = 0
		recipe_calories = @ingredient_names.inject(0) do |acc, i_name|
			val = @ingredients[i_name].properties["calories"] * (teaspoon_counts[count] || 0)
			count += 1
			acc + val
		end
		return recipe_calories != @required_calories
	end
	return false
end

max_score = 0
max_recipe = nil
count = 0
recipe_iterator.each do |teaspoon_counts|
	count += 1
	
	next if should_skip?(teaspoon_counts)

	current_recipe = Recipe.new
	@ingredient_names.zip(teaspoon_counts) { |iname, tcount|  
		current_recipe.add(@ingredients[iname], tcount || 0)
	}
	current_score = current_recipe.score #(scoring_excluded_properties)
	if current_score > max_score
		max_score = current_score
		max_recipe = current_recipe
	end
	print "." if count % 10000 == 0
end

puts "max_score #{max_score} #{max_recipe.inspect}"

#Correct answer part-1 input
#max_score 18965440
# #<Recipe:0x000000019c85c8
#   @recipe_mat_builder=[[4, -2, 0, 0], [0, 5, -1, 0], [-1, 0, 5, 0], [0, 0, -2, 2]],
#   @coeff_values=[24, 29, 31, 16]
# >
