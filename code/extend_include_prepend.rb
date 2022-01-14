module Guitar
  def play_guitar
    p 'play guitar'
  end
end

module Sax
  def play_sax
    p 'play sax'
  end
end

module Piano
  def play_piano
    p 'play piano'
  end
end

class Song
  include Guitar
  prepend Sax
  extend Piano

  def play_guitar
    super
    p 'guitar - playing'
  end

  # will not executing - only in child classes
  # will execute just module method
  def play_sax
    super
    p 'sax - playing'
  end

  # can call extended methods there - and it will be executed there - on declaration of class
  play_piano

  # it will work also
  def self.piano
    play_piano
  end
end

class Song2 < Song
  # can call extended methods there - and it will be executed there - on declaration of class
  play_piano

  # will executing
  def play_sax
    super
    p 'sax - playing'
  end
end

# FOR Song
# BasicObject
# Kernel
# Object
# Guitar (included module)
# Song
# Sax (prepended module)

# FOR Song2
# BasicObject
# Kernel
# Object
# Guitar (included module)
# Song
# Sax (prepended module)
# Song2

puts "\n-------------- Extended Class methods"
Song.piano

puts "\n-------------- Class Song"
song = Song.new

song.play_guitar
song.play_sax

puts "\n-------------- Class Song2"
song2 = Song2.new
song2.play_guitar
song2.play_sax

puts "\n-------------- Class Song - tree"
p song.class
p song.class.ancestors

puts "\n-------------- Class Song2 - tree"
p song2.class
p song2.class.ancestors
