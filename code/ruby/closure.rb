minutes = 40

def meditate(mins)
  return lambda { p mins }
end

p = meditate(minutes)
minutes = nil

p.call


def method1(l)
  return Proc.new { p l }
end

ddd = 'dddddd'
aaa = method1(ddd)
ddd = nil

aaa.call

