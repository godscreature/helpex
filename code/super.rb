class A
  def aa
    p 'aa'
  end
end

class B < A
  def aa
    super   # should exists A.aa
    p 'bb'
  end

  def cc
    # A.cc not exists - will return error
    # super
    p 'cc'
  end
end

a = A.new
b = B.new

puts 'A'
a.aa

puts 'B'
b.aa

