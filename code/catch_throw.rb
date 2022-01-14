puts 'trow catch example - 1'

def m1(a)
  # default value
  throw :lol1, 55 if a == 10
  puts 'Method executed'
  a
end

a = catch :lol1 do
  puts 'try to run method m1'
  m1(10)
end

puts 'trow catch example - 3'

p a
