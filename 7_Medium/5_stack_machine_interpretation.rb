class Minilang
	attr_reader :commands
	attr_accessor :register, :stack, :error_present

	COMMANDS = ['PUSH', 'ADD', 'SUB', 'MULT', 'DIV', 'MOD', 'POP', 'PRINT']
	DIGITS = %w(0 1 2 3 4 5 6 7 8 9)

	@@error_detected = false

	def initialize(input)
		@commands = input.split(' ')
		@register = 0
		@stack = []
		@error_present = false
	end

	def eval
		commands.each do |command|
			if COMMANDS.include?(command)
				next if error_present == true #if an their was an invalid input it iterates over the rest of the commands without executing them
				self.send(command.downcase)
			elsif is_a_number?(command)
				self.register = command.to_i
			else
				self.error_present = true
				puts "Invalid token: #{command}"
			end
		end
	end
	
	private

	def is_a_number?(item)
		arr = item.chars
		return false if arr.count("-") > 1 # example: -1-3

		arr.each do |char|
			next if char == '-' #checks for negative numbers
			return false unless DIGITS.include?(char)
		end

		true
	end

	def can_pop?
		stack.size > 0
	end

	def push #PUSH Push the register value on to the stack. Leave the value in the register.
		self.stack.push(register)
	end

	def add #ADD Pops a value from the stack and adds it to the register value, storing the result in the register.
		self.register = register + self.stack.pop 
	end

	def sub # SUB Pops a value from the stack and subtracts it from the register value, storing the result in the register.
		self.register = register - self.stack.pop 
	end

	def mult # MULT Pops a value from the stack and multiplies it by the register value, storing the result in the register.
		self.register = register * self.stack.pop 
	end

	def div # DIV Pops a value from the stack and divides it into the register value, storing the integer result in the register.
		self.register = register / self.stack.pop 
	end

	def mod # MOD Pops a value from the stack and divides it into the register value, storing the integer remainder of the division in the register.
		self.register = register % self.stack.pop 
	end

	def pop # POP Remove the topmost item from the stack and place in register
		if can_pop?
			self.register = self.stack.pop
		else
			puts "Empty stack!"
			self.error_present = true
		end
	end

	def print # PRINT Print the register value
		p register
	end

end # <--- END OF Minilang Class --->


Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)