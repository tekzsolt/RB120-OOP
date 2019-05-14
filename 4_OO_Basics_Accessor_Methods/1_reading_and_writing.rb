class Person
	def name
		@name
	end

	def name=(name)
		@name = name
	end
end

person1 = Person.new
person1.name = 'Jessica'
puts person1.name