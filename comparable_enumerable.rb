class Person
  attr_accessor :age
  def initialize(age)
    @age = age
  end
end

class PersonComp < Person
  include Comparable
  def <=>(other)
    age <=> other.age
  end
end

# stupid way
# p1 = PersonComp.new(10)
# p2 = PersonComp.new(20)
# p3 = PersonComp.new(30)
# ...
persons = [10, 11, 20, 30].map { |x| PersonComp.new(x) }

p 'sort:'
p persons.sort
p 'max:'
p persons.max
p 'min:'
p persons.min
p 'min, max:'
p persons.minmax
p '< >'
p persons[2] < persons[0]
p 'between'
p persons[0].between?(persons[1], persons[2])

puts "\n"

class PersonColl < Person
  include Enumerable

  def initialize(persons)
    @persons = persons.map { |x| PersonComp.new(x) }
  end

  def each(&block)
    @persons.each(&block)
  end
end

persons2 = PersonColl.new([10, 50, 8, 20, 30, 25])

p 'sort'
# working because we have array of PersonComp, not of Person
p persons2.sort
p 'first'
# working with Person also
p persons2.first
p 'select'
# working with Person also
p persons2.select { |x| x.age == 20 }
p 'select'
# working with Person also
p persons2.select { |x| [20, 25, 30].include?(x.age) }
