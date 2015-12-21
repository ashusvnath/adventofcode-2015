require 'prime'

target = (ARGV[0] || "150").to_i

class PrimeFactorSumCalculator
	def initialize
		@calculated = {}
	end

	def get_value(p,i)
		@calculated[[p,i]] ||= (p**(i + 1) - 1)/(p - 1)
	end
end

pfsc = PrimeFactorSumCalculator.new

2.upto(target/10) do |idx|
	sum_of_factors = Prime.prime_division(idx).map{|(p,i)| pfsc.get_value(p,i)}.inject(&:*)
	(puts "#{sum_of_factors} #{idx}"; break) if sum_of_factors*10 >= target
end
