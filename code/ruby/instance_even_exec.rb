puts "\n Issue -------------------------------------------"

class Person1
  code = proc { puts self }

  define_method :name do
    # при виконанні проку - контекст буде не найактуальніший, а Person1 - контекст, в якому описаний цей метод
    code.call
  end
end

class Developer1 < Person1
end

Person1.new.name      # Person1
Developer1.new.name   # Person1

puts "\n Solution -------------------------------------------"

class Person2
  code = proc { puts self }

  define_method :name do
    # тут вже буде інший контекст, self.class - буде повертати контекст, в якому метод викликано, а не описано
    self.class.instance_eval &code
  end
end

class Developer2 < Person2
end

Person2.new.name
Developer2.new.name

puts "\n Issue with params -------------------------------------------"

class Person3
  code = proc { |str| puts "#{str} #{self}" }

  define_method :name do
    # Майже теж саме що і instance_eval, проте можна ще передати параметр
    self.class.instance_exec 'Loool', &code
  end
end

class Developer3 < Person3
end

Person3.new.name
Developer3.new.name
