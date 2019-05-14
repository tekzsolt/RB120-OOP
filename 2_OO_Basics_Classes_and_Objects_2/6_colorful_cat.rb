class Cat
	COLOUR = "purple"

	attr_reader :name

	def initialize(name)
		@name = name
	end

	def greet
		puts "Hello! My name is #{name} and I'm a #{COLOUR} cat!"
	end
end

kitty = Cat.new('Sophie')
kitty.greet # => Hello! My name is Sophie and I'm a purple cat!