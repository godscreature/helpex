END {
      puts 'END'
}

BEGIN {
  puts 'BEGIN'
}

puts 'This is program'

puts "\n---------------------------------------"

a = begin
      10
    end

puts a: a

begin
  a = 20
end

puts a: a

begin
  puts 'LOL2'
end

puts "\n---------------------------------------"

c = 0

begin
  puts "try to do: #{a} / #{c}"
  b = a / c
rescue ZeroDivisionError => e
  puts e.message
  c = 2
  retry
rescue StandardError => e
  puts e.message
else
  puts 'no exceptions'
ensure
  puts 'this code always executed'
end

puts a: a, b: b, c: c

puts "\n---------------------------------------"

begin
  raise 'Test exception.'
  # raise ExceptionType, "Error Message"
rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
end
