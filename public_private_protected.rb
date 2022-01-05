class A
  def aa(other)
    other.bb
  end

  def jj
    ii
  end

  private

  def ii
    puts 'ii'
  end
end

class B < A

  protected

  def bb
    puts 'bb'
  end

end

class C < B
  def cc
    bb
  end

  def xx
    ii
  end
end

a = A.new
b = B.new
c = C.new

puts "\n ----------- Protected"
# error: undefined method bb
# a.aa(a)

# error: protected method bb called for B
# i can't execute b.bb in class A -> class A is not child of B
# a.aa(b)

# error: protected method bb called for C
# i can't execute c.bb in class A -> class A is not child of B
# a.aa(c)

# error: protected method bb called for B
# i can't execute b.bb, I can execute protected method only in class
# b.bb

# execute B.aa, not A.aa and it's works
# to the B.aa pass class B, which has method bb
b.aa(b)

# execute B.aa, not A.aa and it's works
# to the B.aa pass class C, which has method bb
b.aa(c)

# execute C.aa, not A.aa and it's works
# to the C.aa pass class B, which has method bb
c.aa(b)

# execute C.aa, not A.aa and it's works
# to the C.aa pass class C, which has method bb
c.aa(c)

# can not execute protected method in object, should do it only in Class
# c.bb

# execute C.bb, and it's works
c.cc

puts "\n ----------- Private"
# ii is private - can execute only in class A - will return error
# a.ii

# public method which use own private method - works
a.jj

# ii is private - can execute only in class A and children, not in object
# b.ii
# public extended method which use own class A private method - works
b.jj

# can execute public extended method
c.jj

# works correct - can use private method in children
c.xx
