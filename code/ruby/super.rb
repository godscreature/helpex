class A
  def aa
    p 'aa'
  end

  def rr(a1)
    p a1
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

  def rr(a1)
    # ця штука викличе батьківський метод з параметром - все очевидно
    super(a1)
    # ця штука - автоматично підставить в super пачку аргументів які заходять в метод
    # тому якщо в методі буде прийматися a1, b1 - то ця стрічка поверне ArgumentError на стрічці батьківського класу:
    # def rr(a1)
    super
    # ця штука - для того, щоб явно вказати - викликати без параметрів
    # якщо в метод передається 1 або кілька параметрів, а в батьківському методі їх нема, то просто super поверне помилку (див. вище)
    # super()
  end
end

a = A.new
b = B.new

puts 'A'
a.aa

puts 'B'
b.aa

b.rr('LOL')
