require 'json'

filename = ARGV[0] || "day-12-input.txt"

class Hash
	def clean(key)
		return "" if self.values.include?(key)
		self.keys.each do |k|
			v = self[k]
			puts "Hash\#clean #{v.class}"
			self[k] = (v.is_a?(Hash) || v.is_a?(Array)) ? v.clean(key) : v
		end
		return self
	end
end

class Array
	def clean(key)
		self.map{|element| puts "Array\#clean #{element.class}"; (element.is_a?(Hash) || element.is_a?(Array))  ? element.clean(key) : element }
	end
end

File.readlines(filename).each { |line|
	puts line.scan(/-?\d+/).map(&:to_i).inject(0){|a,v| a+v}
	data = JSON.parse(line)
	new_line = JSON.generate(data.clean("red"))
	puts new_line
	puts new_line.scan(/-?\d+/).map(&:to_i).inject(0){|a,v| a+v}
}
