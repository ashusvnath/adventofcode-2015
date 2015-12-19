require 'minitest/autorun'
require './day-19-helper'

describe "Day19 and utils" do
	describe "Array\#custom_replace" do
		it "should replace" do
			x = [1, 2, 3, 4]
			expected_x = [1, 'asdf', 4]
			x.custom_replace(1,2, 'asdf').must_equal(expected_x)
		end
	end

	describe "String\#get_all_indices" do
		it "should do it!!" do
			"asdfasdf".get_all_indices('as').must_equal([0,4])
		end

		it "should yield results when given block" do
			"asdfasdf".get_all_indices('as') do |value|
 				assert([0, 4].include?(value), "Yielded values must be 0 or 4")
			end
		end
	end

	describe "Day19\#results" do
		it "should work for simple input production" do
			productions = {"H" => ["OH"]}
			start = "HOH"
			result = Day19.new(productions, start).results()
			result.must_equal(["OHOH", "HOOH"])
		end

		it "should work for complex input productions" do
			productions = {"H" => ["OH", "HO"], "O" => ["HH"]}
			start = "HOH"
			result = Day19.new(productions, start).results()
			result.must_equal(["OHOH", "HOOH", "HOHO", "HHHH"])
		end
	end

	describe "Day19\#smallest_production_length" do
		it "should return length of smallest production starting from 'e' to reach 'HOH'" do
			productions = {"H" => ["OH", "HO"], "O" => ["HH"], "e" => ["H", "O"]}
			start = "HOH"
			result = Day19.new(productions, start).smallest_production_length
			result.must_equal(3)
		end
	end

	describe "Day19\#smallest_production_length" do
		it "should return length of smallest reduction from 'HOH' -> 'e'" do
			productions = {"e" => ["H", "O"]}
			reversal = {"OH" => "H", "HO" => "H", "HH" => "O"}
			start = "HOH"
			result = Day19.new(productions, start, reversal).smallest_production_length_by_reduction
			result.must_equal(3)
		end
	end
end
