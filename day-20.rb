require 'prime'

target = (ARGV[0] || "150").to_i
houses_per_elf = (ARGV[1] || target).to_i
presents_per_elf = (ARGV[2] || 10).to_i

class PrimeFactorSumCalculator
	def initialize
		@calculated = {}
	end

	def get_value(p,i)
		@calculated[[p,i]] ||= (p**(i + 1) - 1)/(p - 1)
	end
end

class Fixnum
	def each_factor(limit, &block)
		count = 0
		limit ||=self
		start = [self/limit,1].max
		(start..self).each{|num| yield num if self % num == 0 }
	end
end


if __FILE__ == $0
	pfsc = PrimeFactorSumCalculator.new


	house_number = 0
	part1_answer = 0
	start = Time.now
	2.upto(target/10) do |idx|
		house_number = idx
		sum_of_factors = Prime.prime_division(idx).map{|(p,i)| pfsc.get_value(p,i)}.inject(&:*)
		break if (part1_answer = sum_of_factors*10) >= target
	end
	puts "Puts house #{house_number} receives #{part1_answer} presents"
	total_time_taken = (Time.now - start).to_i
	puts "Total time taken for Step 1#{total_time_taken}"


	start = Time.now
	part1_answer.upto(target/10) do |house|
		presents = 0
		house.each_factor(houses_per_elf) {|v| presents  += v*presents_per_elf}
		(puts "Puts house #{house} receives #{presents} presents" ; break) if presents >= target
		print "." if house % 100 == 0
	end
	total_time_taken = (Time.now-start).to_i

	puts "Total time taken for Step #{total_time_taken} "
end