class Piano
  attr_accessor :brand

  def initialize(brand)
    # instance scope
    @brand = brand
  end

  # instance scope
  def brand_id
    return "id[#{brand}]"
  end

  #class scope
  def self.count_pedals
    puts '33 pedals'
  end

  #instance scope - can has the same name
  def count_pedals
    puts '3 pedals'
  end

  # can run in class, will run on 'new'
  count_pedals

end

piano = Piano.new('Yamaha')

puts piano.brand_id
puts piano.count_pedals

puts Piano.count_pedals