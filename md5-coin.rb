require 'digest/md5'

prefix = ARGV[0]
num_zeros = (ARGV[1] || "5").to_i
required_md5_prefix = "0" * num_zeros

i = 0
while true
	i += 1
	d = Digest::MD5.hexdigest("#{prefix}#{i}")	
	break if d.start_with?(required_md5_prefix)
end
puts i 
