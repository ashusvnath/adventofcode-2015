input = open('day-19-input.txt').read.scan(/(^([a-zA-Z]*?) => ([a-zA-Z]*?)$)|(^[a-zA-Z]*$)/)
replacements = Hash.new { |h, k| h[k] = [] }
original = ""

input.each_with_index do |val,i|
    if i == input.length-1
        original = val[3]
    else
        element = val[1]
        replacement = val[2]

        if (element && replacement)
            replacements[element] <<= replacement
        end
    end
end

molecule_elements = original.scan(/([a-zA-Z][a-z]?)/)
permutations = []

molecule_elements.each_with_index do |val,i|
    element = val[0]
    mutations = replacements[element]
    next if mutations.length == 0

    mutations.each do |mutation|
        new_molecule = ''
        molecule_elements.each_with_index do |e,j|
            element_string = e[0]
            element_string = mutation if i == j
            new_molecule += element_string
        end

        permutations << new_molecule
    end
end

permutations.uniq!
puts "part one: #{permutations.length}"

#part two

root_element = 'e'
count = 0
ordered_replacements = replacements.values.flatten.sort_by(&:size).reverse
molecule = original

while (molecule != 'e') do
    count += 1
    break if count >= 1000 #because something might be going wrong if this is happening

    ordered_replacements.each do |replacement|
        if  molecule.include?(replacement)
            element = replacement
            replacements.each do |key, value|
                if value.include?(replacement)
                    element = key
                    break
                end
            end
            new_molecule = molecule
            new_molecule = new_molecule .sub(replacement,element)
            if (element != 'e')
                molecule = new_molecule
                break
            else
                if (new_molecule == 'e')
                    molecule = new_molecule
                    break
                end
            end
        end
    end
end

puts "part two: #{count}"