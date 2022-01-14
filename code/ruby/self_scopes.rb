puts 'self in class, self in instance, class method, instance method:'

class A
  attr_accessor :a

  # class scope
  @@b = 20

  def initialize
    # instance scope
    @a = 10
  end

  # can use in class methods and in instance methods
  @@b += 10

  def get_b
    # instance scope
    @@b
  end

  def instance_method1
    # local var
    @c = 30
    puts 'instance method 1'
  end

  def self.class_method1
    # class scope
    puts 'class method 1'
  end

  def sss
    # can get access to local var of other method @c is empty
    puts "LOL: #{@c}"
    # instance scope
    self
  end

  # class scope
  puts "class self: #{self}"
end

class B < A
  # class var
  @@c = 110

  def initialize
    # instance scope
    # instance var
    @d = 200
  end

  def get_b
    # ok - instance method can get access to class var
    # children can get access to var of parent
    @@b
  end

  def self.get_c
    # ok - class method and class var
    @@c
  end

  def get_c
    # ok - instance method can get access to class var
    @@c
  end

  def self.get_d
    # will return empty - instance var not allowed in class scope
    @d
  end

  def get_d
    # ok - instance method can get access to instance var
    @d
  end
end

a = A.new

puts a.sss

# main scope
puts "main self: #{self}"

puts "instance self from instance method: #{a.sss}"
puts "instance self by 'itself' method: #{a.itself}"

puts 'run instance method from instance \'a\':'
a.instance_method1
puts 'run class method from class \'A\''
A.class_method1

puts a.a

b = B.new
puts b.get_b

puts "class method get_c return class var: #{B.get_c}"
puts "instance method get_c return class var: #{b.get_c}"

puts "class method get_d return instance var: #{B.get_d}"
puts "instance method get_d return instance var: #{b.get_d}"

puts "\nmodules with methods: --------------------------------------"

module M1
  ABC = 'abc'
  def self_return
    self
  end

  def self.self_return2
    self
  end

  module M3
    def self.aaa
      puts "have access in M3: #{ABC}"
    end
  end

end

module M2
  def self_return2
    self
  end

  def self.self_return3
    self
  end

  self
end

class C
  include M1
  extend M2
end

class D < C
end

c = C.new

puts M1.self_return2
puts c.self_return
puts C.self_return2

puts M2.self_return3

puts M1::ABC
puts C::ABC
puts D::ABC

# wouldn't working
# puts M1::M3::ABC

M1::M3.aaa