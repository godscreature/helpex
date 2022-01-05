# Blocks #################################################
puts "\n-------Blocks:"

def hello_bl(&block)
  @aaa = '!!!'
  puts 'Method'

  puts block_given?

  block.call

  yield
end

hello_bl do
  puts "Block1 #{@aaa}"
end

# Procs ######################################################
puts "\n-------Procs:"

# создаем с помощью конструктора
p1 = Proc.new { puts 'proc #1' }
# создаем с помощью бортового метода Kernel
p2 = proc do
  puts "proc #2 #{@bbb}"
  # остановит прок, метод и ваще прогу
  # return
end
p3 = Proc.new do |arg1, arg2, arg3|
  puts "proc #3 #{arg1}"
end

def hello_pr(p1, p2, p3)
  @bbb = '!!!'
  p1.call
  p2.call
  p3.call('Den')
end

hello_pr(p1, p2, p3)

# получение прока с блока
def make_proc(&block)
  block
end
proc_from_block = make_proc { |name| puts "Hello, #{name}" }
puts proc_from_block.lambda?

# Lambdas ######################################################
puts "\n-------Lambdas:"

# создаем с помощью бортового метода Kernel
l1 = lambda { puts 'lambda' }
l1.call

l2 = lambda do |name|
  puts "hello, #{name}"
  return
end

# will be error
#l2.call
l2.call('Den')
puts l2.lambda?

def hello_lm(l1)
  puts 'Method'
  l1.call('Den')
  puts 'Working after return'
end

hello_lm(l2)

l3 = -> { puts 'Lambda 3, without params' }
l4 = -> (x, y) { puts "Lambda 4, param1: #{x}, param2: #{y}" }

l3.call
l4.call(10, 20)

# Examples ######################################################
puts "\n-------Examples:"

def test1
  [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map { |a, b| return a if a + b > 10 }
end
puts "\ntest1:"
puts test1

def test2(&block)
  [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map(&block)
end
puts "\ntest2:"
puts test2 { |a, b| a if a + b > 10 }

puts "\ntest3:"
p11 = proc { |a| puts "#{a}" }
[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map(&p11)

# one element [a, b] transformed to 2 parameters a, b
puts "\ntest4:"
p12 = proc { |a, b| puts "#{a}, #{b}, sum = #{a + b}" }
[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map(&p12)

puts "\ntest5:"
l11 = lambda { |a| puts "#{a}" }
[[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map(&l11)

# Error - wrong number of arguments
# one element [a, b] will not transformed to 2 parameters a, b
# l12 = lambda { |a, b| puts "#{a}, #{b}, sum == #{a + b}" }
# [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]].map(&l12)

puts "\ntest6:"
puts :to_s.to_proc.call(1).class
[1, 2, 3, 4, 5].map(&:to_s).map { |a| puts "#{a} -> #{a.class}" }

puts "\ntest7:"
class Homer
  attr_accessor :age

  def initialize(age)
    @age = age
  end

  def self.to_proc
    proc { |x| self.new(x) }
  end
end

homers = [1, 2, 3].map(&Homer)
homers.each { |h| puts "It is #{h.class} with age #{h.age}" }
puts homers
