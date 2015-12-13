input = ARGV[0] || "3113322113"
ainput = [input]
iter_count = (ARGV[1] || "40").to_i

def find_next(fun_input)
    current_char = nil
    current_run_count = 0
    next_seq = ""
    fun_input.chars.to_a.each{|c|
        if current_char != c
            next_seq += (current_char.nil? ? "" : "#{current_run_count}#{current_char}")
            current_run_count = 1
            current_char = c
        else
            current_run_count += 1
        end
    }
    next_seq += "#{current_run_count}#{current_char}"
    return next_seq
end

count = 0
while count < iter_count
    count += 1
    ainput = ainput.map{|i| i.gsub("2111", "2 111").split}.flatten
    next_ainput = ainput.map{|i| find_next(i)}
    next_length = next_ainput.inject(0){|acc, str| acc + str.length}
    
    puts "#{count}. #{next_length}"
    ainput = next_ainput
end
