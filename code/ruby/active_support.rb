# can use without rails
require 'active_support/all'

class P

  # class attr accessor - can use because of active support
  cattr_accessor :lol

  def initialize(b)
    @b = b
  end
end

P.lol = 123
p P.lol

p = P.new(500)

# get instance variables values - can use because of active support
p p.instance_values

html = '<strong>Active Support give extended tools for String</strong>'

# will add '<br/>'
html << '<br/>'

# just change the flag - has no any transformations
html = html.html_safe

# because now html_safe? = true - will be add '&lt;br/&gt;' instead '<br/>'
html << '<br/>'

p html
