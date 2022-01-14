# matching regular expressions, that will return the index of the start of the match or nil
s = 'how now brown cow'

p s =~ /cow/ # => 14
p s =~ /now/ # => 4
p s =~ /cat/ # => nil

