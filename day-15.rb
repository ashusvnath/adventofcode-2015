class Ingredient
	attr_reader :name, :properties

	@@mapped_values = {}

	def initialize(name, properties)
		@name = name
		@properties = properties
	end

	def *(factor)
		if factor.is_a?(Numeric)
			new_name = "#{factor}*#{@name}"
			@@mapped_values[new_name] if @@mapped_values.keys.include?(new_name)
			new_properties = {}
			@properties.keys.each do |property|
				new_properties[property] = @properties[property] * factor
			end
			new_ingredient = Ingredient.new("#{factor}*#{@name}", new_properties)
			@@mapped_values[new_name] = new_ingredient
			return new_ingredient
		end
	end

	def +(other)
		if other.is_a?(Ingredient)
			new_properties = {}
			@properties.keys.each do |property|
				new_properties[property] = [@properties[property] + (other.properties[property] || 0), 0].max
			end
			return Ingredient.new("#{@name}+#{other.name}", new_properties)
		end
	end

	def to_s
		"#{@name} : #{@properties}"
	end
end


class Recipe
	def initialize
		@parts = []
	end

	def add(ingredient, teaspoon)
		@parts << ingredient * teaspoon
	end

	def score(excluded_properties = [])
		ingredient = Ingredient
		result = @parts.inject(nil) do |final_score, part|
			final_score ? final_score + part : part
		end
		result_properties = result.properties
		scoring_attributes = result_properties.keys.reject{|key|
			excluded_properties.include?(key)
		}
		scoring_values = scoring_attributes.map{|sa| result_properties[sa]}
		return scoring_values.inject(&:*)
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
		while (!is_valid && !done?)
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

ingredient_line = /^(?<name>\w+):(?<properties>(.*))$/
properites_segment = /(?<property>\w+)\s+(?<value>(\+|-)?\d+)/

ingredients = {}

File.readlines(filename).each do |line|
	result = ingredient_line.match(line)
	name = result["name"]
	properties = result["properties"].scan(properites_segment).map{|p| p[1] = p[1].to_i; p}
	ingredient = Ingredient.new(name, Hash[properties])
	ingredients[name] = ingredient
	#puts ingredient
end

TOTAL_TEASPOONS = 100
count = 1

ingredient_names = ingredients.keys

recipe_iterator = RecipeIterator.new(TOTAL_TEASPOONS, ingredient_names.length)
scoring_excluded_properties = ["calories"]
#p recipe_iterator

max_score = 0
max_recipe = nil
count = 0
recipe_iterator.each do |teaspoon_counts|
	count += 1
	current_recipe = Recipe.new
	#puts "#{count}  #{teaspoon_counts} #{teaspoon_counts.inject(&:+)}"
	ingredient_names.each_with_index do |name, index|
		current_recipe.add(ingredients[name], teaspoon_counts[index] || 0)
	end
	current_score = current_recipe.score(scoring_excluded_properties)
	if current_score > max_score
		max_score = current_score
		max_recipe = current_recipe
	end
	print "." if count % 10000 == 0
end

puts "max_score #{max_score} #{max_recipe.inspect}"

# max_score 26834592
# Winning recipe :
# #<Recipe:0x0000000170bb50
#@parts=[
##<Ingredient:0x0000000170ba10 @name="24*Frosting", @properties={"capacity"=>96, "durability"=>-48, "flavor"=>0, "texture"=>0, "calories"=>120}>,
##<Ingredient:0x0000000170b948 @name="35*Candy", @properties={"capacity"=>0, "durability"=>175, "flavor"=>-35, "texture"=>0, "calories"=>280}>,
##<Ingredient:0x0000000170b880 @name="25*Butterscotch", @properties={"capacity"=>-25, "durability"=>0, "flavor"=>125, "texture"=>0, "calories"=>150}>,
##<Ingredient:0x0000000170b7b8 @name="16*Sugar", @properties={"capacity"=>0, "durability"=>0, "flavor"=>-32, "texture"=>32, "calories"=>16}>
#]>
