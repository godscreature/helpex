a = 0b0011_1100

p '+'+a.to_s(2)
p (~a).to_s(2)

b = 0b0000_1100
puts "\n"
p b.to_s(2)
p (b<<2).to_s(2)

puts "\n"
p b.to_s(2)
p (b>>2).to_s(2)

z = [1, 2, 3]

z << 'a' << 4 << [5, 6]

p z
