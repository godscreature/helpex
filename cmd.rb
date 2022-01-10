puts "\n backtick --------------------------------------"

# will exception if command is invalid

output = `ls -la`

puts "output is #{output}"
puts $?.success?

output = 'ls -la'

puts `#{output}`
# check the status
puts $?.success?

puts "\n system ---------------------------------------"

# will no exception if command is invalid - always performed
# return: true - zero status (ok), false - not zero status, nil - fails
output = system('xxxxxxx')
puts "output is #{output}"

puts "\n exec ---------------------------------------"

exec('ls -la')

puts "\n sh ---------------------------------------"

# call system under the hood
sh('ls -la')