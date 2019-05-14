# Create an object-oriented number guessing class for 
# numbers in the range 1 to 100, with a limit of 7 
# guesses per game. The game should play like this:

class GuessingGame
	attr_accessor :limit, :guess

	RANGE = 1..100

	def initialize
		@limit = 7
		@guess = nil
		@secret_number = random_number
	end

	def play
		loop do
			display_guesses_remained
			guess_prompt
			check_guess

			if number_guessed?
				puts "You won!"
				puts ""
				reset
			end

			decrease_limit
			break if limit == 0
		end

		puts "You have no more guesses. You lost!" if limit == 0
	end


	private

	def random_number
		rand(RANGE)
	end

	def display_guesses_remained
		puts "You have #{limit} guesses remaining."
	end

	def guess_prompt
		puts "Enter a number between 1 and 100:"
		answer = nil
		loop do
			answer = gets.chomp.to_i
			break if RANGE.cover?(answer) # #cover? method works faster than #include? with ranges
			puts "Invalid guess. Enter a number between 1 and 100:"
		end
		self.guess = answer
	end

	def check_guess
		if guess < @secret_number
			puts "Your guess is too low."
		elsif guess > @secret_number
			puts "Your guess is too high."
		else
			puts "That's the number!"
		end
	end

	def number_guessed?
		guess == @secret_number
	end

	def reset
		self.limit = 8
		@secret_number = random_number
	end

	def decrease_limit
		self.limit -= 1
	end

end

game = GuessingGame.new
game.play