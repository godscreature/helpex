puts 'trow catch example - 1'

def m1(a)
  puts 'Method'
  puts a: a
  throw :lol1 if a == 10
end

catch :lol1 do
  puts 'try to run method m1'
  m1(10)
end

puts 'trow catch example - 3'
