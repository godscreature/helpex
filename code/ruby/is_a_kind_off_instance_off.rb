p 'abc.'.is_a?(String)  # true

class Human
end
class Person < Human
end

person = Person.new

p person.instance_of?(Person) # => true
p person.instance_of?(Human)  # => false
p person.is_a?(Person)        # => true
p person.is_a?(Human)         # => true
p person.kind_of?(Person)     # => true
p person.kind_of?(Human)      # => true

puts "\n"

module Mod1
  module Mod2

  end
end

class C
  include Mod1
end

class D < C
end

c = C.new
d = D.new

p c.instance_of? Mod1     # false
p d.instance_of? Mod1     # false
p c.kind_of? Mod1     # true
p d.kind_of? Mod1     # true
p c.kind_of? Mod1::Mod2     # false
p d.kind_of? Mod1::Mod2     # false
