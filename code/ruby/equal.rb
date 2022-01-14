puts "\n-------------- =="
p 2 == 2    # true
p 2 == 2.0  # true
p 2 == '2'  # false

class A; end
class B < A; end
class C; end

a = A.new
b = B.new
c = C.new

p a == a # true
p a == b # true
p a == c # false

puts "\n-------------- equal?"

a = "zen"
b = "zen"
p "Id:#{a.object_id}"
p "Id:#{b.object_id}"
p a.equal? b    # false

a = "zen"
b = a
p "Id:#{a.object_id}"
p "Id:#{b.object_id}"
p a.equal? b    # true

puts "\n-------------- eql?"

p "zen".eql? "zen"  # true
p "zen".hash == "zen".hash # true

p 2 == 2.0 # true
p 2.eql? 2.0 # false
p 2.hash == 2.0.hash # false

puts "\n-------------- ==="

x = 1
case x
# in every when - use different === realization
when 1
  p '1'
when 1.0
  p '1.0'
when (0..10)
  p '(0..10)'
when /abc/
  p '/abc/'
else
  p 'no one'
end

# FOR EXAMPLE:
#
# class Integer
#   def ===(other)
#     self.to_f == other.to_f
#   end
# end
#
# class RegExp
#   def ===(other)
#     self =~ other
#   end
# end
#
# class Range
#   def ===(other)
#     self.cover?(other)
#   end
# end
#
# class Class
#   def ===(other)
#     self == other
#   end
# end
#
# class Object
#   def ===(other)
#     self == other
#   end
# end
