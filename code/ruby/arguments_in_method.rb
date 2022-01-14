def lol(*args, **args2, &block)
  args.map { |x| "type: #{x.class}; value: #{x}" }
  puts "args: #{args}"

  args2.map { |x| "type: #{x.class}; value: #{x}" }
  puts "key args: #{args2}"

  yield
end

lol('aa', 'bb', 10, aa: 10, bb: 100) {
  puts 'execute code in block'
}
