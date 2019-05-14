# Create an object-oriented number guessing class for 
# numbers in the range 1 to 100, with a limit of 7 
# guesses per game. The game should play like this:

# Update your solution to accept a low and high value when you create 
# a GuessingGame object, and use those values to compute a secret number
# for the game. You should also change the number of guesses allowed so 
# the user can always win if she uses a good strategy. You can compute 
# the number of guesses with: Math.log2(size_of_range).to_i + 1

class GuessingGame
	attr_accessor :limit, :guess
	attr_reader :range

	def initialize(first_nr, last_nr)
		@range = first_nr..last_nr
		@limit = Math.log2(last_nr - first_nr + 1).to_i + 1
		@guess = nil
		@secret_number = random_number
	end

	def play
		if !guess.nil? # block handles if #play is called multiple times
			reset
			decrease_limit
		end

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
		rand(range)
	end

	def display_guesses_remained
		puts "You have #{limit} guesses remaining."
	end

	def guess_prompt
		puts "Enter a number between #{range.first} and #{range.last}:"
		answer = nil
		loop do
			answer = gets.chomp.to_i
			break if range.cover?(answer) # #cover? method works faster than #include? with ranges
			puts "Invalid guess. Enter a number between #{range.first} and #{range.last}:"
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
		self.limit = Math.log2(range.last - range.first + 1).to_i + 2
		@secret_number = random_number
	end

	def decrease_limit
		self.limit -= 1
	end

end

game = GuessingGame.new
game.play
game.play