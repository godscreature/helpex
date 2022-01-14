# Marshaling - це серіалізація-десеріалізація

hello_world = 'hello world!'
serialized_string = Marshal.dump(hello_world)

deserialized_hello_world = Marshal.load(serialized_string)

p hello_world.object_id
p hello_world

p serialized_string.object_id
p serialized_string

p deserialized_hello_world.object_id
p deserialized_hello_world

puts "\n can control serialization process"

User = Struct.new(:age, :fullname, :roles) do
  def marshal_dump
    {}.tap do |result|
      result[:age]      = age
      result[:fullname] = fullname if fullname.size <= 64
      result[:roles]    = roles unless roles.include? :admin
    end
  end

  def marshal_load(serialized_user)
    self.age      = serialized_user[:age]
    self.fullname = serialized_user[:fullname]
    self.roles    = serialized_user[:roles] || []
    end
end

user = User.new(42, 'Mehdi Farsi', [:admin, :operator])
user_dump = Marshal.dump(user)
p user_dump

original_user = Marshal.load(user_dump)
p original_user
