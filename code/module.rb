Z = 0

# создание модуля
module Mod1
end

# открытие для дополнения
module Mod1
  Z = 1
  X = 10

  def method1
    puts 'Mod1 - method 1'
  end

  def x
    X
  end
end

module Mod1
  alias alias1 method1
end

module Mod1
  remove_method :method1
end

# внутренний модуль
module Mod1
  module Mod1_1
    Z = 2
    # if Z is empty there - will return Mod1::Z
    p Z
    p Mod1::Z
    p ::Z

    p Module.nesting
  end
end

# внутренний модуль
module Mod1::Mod1_2
  Z = 2

  # if Z is empty there - will return error
  p Z
  p Mod1::Z
  p ::Z

  p Module.nesting

  def method2
    puts 'Mod1::Mod1_2 - class method 2'
  end

  # преорбазовывает метод экземпляра в метод класса и можно писать такое: Mod1::Mod1_2.class_method1
  module_function

  def class_method1
    puts 'Mod1::Mod1_2 - class method 1'
  end

end

Mod1::Mod1_2.class_method1

include Mod1

p X   # 10
p x   # 10

class Aa
  extend Mod1::Mod1_2
end

Aa.method2