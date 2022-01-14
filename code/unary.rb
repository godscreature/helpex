# I can modify class String, but it will 'monkey patch' - it's not good
class String2 < String

  # define realization for unary -
  def -@
    downcase
  end

  # define realization for unary +
  def +@
    upcase
  end

  # Binary Ones - binary not: 0010 -> 1101
  def ~
    'some actions'
  end

  # define realization for unary *
  # should return an array
  def to_a
    self.split('')
  end

  # define realization for ! and 'not'
  def !
    swapcase
  end

  # define realization for &
  def to_proc
    Proc.new { |x| x+'-'+self }
  end
end

str = String2.new('Hello world!')

p -str
p +str
p ~str
p *str
p !str

p %w(a b).map(&str)

d = 10
e = 2
d = d**e
p d