class A
  def bye
    puts 'bye'
  end
end

a = A.new
b = A.new

class << a
  def hello
    puts self
  end
end

class << a
  def bye
    puts 'go away'
  end
end

# can be defined like this:
# def a.method2
#   p 'method 2'
# end

# i see my method in singleton instance
puts "instance singleton methods: #{a.singleton_methods}"
puts a.hello
# our overwrite method
puts a.bye

# there is not method 'hello'
puts "instance singleton methods: #{b.singleton_methods}"
# get error
# puts b.hello

# default method
puts b.bye
