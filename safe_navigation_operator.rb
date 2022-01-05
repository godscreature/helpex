class Piano
  def keys
    '32'
  end

  def pedals
    # return nil
  end
end

piano = Piano.new

puts piano.keys.length

# safe navigation
# method pedals - will return nil and there is no 'length' - will be error without &.
puts piano.pedals&.length


piano2 = nil
# will return nil without errors
puts piano2&.keys&.length