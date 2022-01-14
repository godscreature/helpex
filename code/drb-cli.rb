require 'drb/drb'

# DRb.start_service
# remote_object = DRbObject.new_with_uri('druby://localhost:9999')
#
# p remote_object.greet   #=> 'Hello, world!'

# OR next example

DRb.start_service
queue = DRbObject.new_with_uri('druby://localhost:9999')

loop do
  data = queue.pop

  # Process the data
  puts "Processing #{data}"
end