require 'drb/drb'

# class MyApp
#   def greet
#     'Hello, world!'
#   end
# end
#
# object = MyApp.new
#
# DRb.start_service('druby://localhost:9999', object)
# DRb.thread.join

# OR next example

queue = Queue.new

DRb.start_service('druby://localhost:9999', queue)
DRb.thread.join
