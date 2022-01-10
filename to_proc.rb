class A
  def to_proc
    p 'method to_proc'
    proc do |x|
      p 'This is A, converted to Proc'
      p "x = #{x}"
    end
  end
end

a = A.new

def ttt
  yield
end

puts "\n just method with block ----------------------"
ttt { p 'just a block' }

puts "\n a, to_proc, call ----------------------"
p a.class
p a.to_proc
a.to_proc.call(1)

puts "\n pass object as block to the method ----------------------"
ttt(&a)

puts "\n transforming ----------------------"
numbers = [1, 2, 3, 4, 5]
numbers.map &a

numbers.map { |x| a }
