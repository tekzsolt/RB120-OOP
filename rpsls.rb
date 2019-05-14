class Move
	VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

	def initialize(value)
		@value = value
	end

	def scissors?
		@value == 'scissors'
	end

	def rock?
		@value == 'rock'
	end

	def paper?
		@value == 'paper'
	end

	def lizard?
		@value == 'lizard'
	end

	def spock?
		@value == 'spock'
	end

	def >(other_move)
		# no need for self.rock? as it's already an instance method
		(rock? && (other_move.scissors? || other_move.lizard?)) ||
		(paper? && (other_move.rock? || other_move.spock?)) ||
		(scissors? && (other_move.paper? || other_move.lizard?)) ||
		(lizard? && (other_move.paper? || other_move.spock?)) ||
		(spock? && (other_move.rock? || other_move.scissors?))
	end

	def <(other_move)
		# no need for self.rock? as it's already an instance method
		(rock? && (other_move.paper? || other_move.spock?)) ||
		(paper? && (other_move.scissors? || other_move.lizard?)) ||
		(scissors? && (other_move.rock? || other_move.spock?)) ||
		(lizard? && (other_move.rock? || other_move.scissors?)) ||
		(spock? && (other_move.paper? || other_move.lizard?))
	end

	def to_s
		@value
	end

end

class Player
	attr_accessor :move, :name, :score, :history_of_moves

	def initialize
		#@move = nil --> this will be nil automatically 
		set_name #method in Human and Computer class
		@score = 0
		@history_of_moves = []
	end

	def display_history_of_moves
		history_of_moves.join(', ')
	end
end

class Human < Player

	def set_name
		n = nil
			loop do
				puts "Hi, what's your name?"
				n = gets.chomp
				break unless n.empty?
				puts "Sorry, must enter a value."
			end
			self.name = n
	end

	def choose
		choice = nil
			loop do
				puts "Please choose rock, paper, scissors, lizard or spock:"
				choice = gets.chomp
				break if Move::VALUES.include?(choice)
				puts "Sorry, invalid choice!"
			end
			self.move = Move.new(choice)
			history_of_moves << choice
	end

end

class Computer < Player
	def set_name
		self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
	end

	def choose
		mv = Move::VALUES.sample
		self.move = Move.new(mv)
		history_of_moves << mv
	end
end

# Game Orchestration Engine
class RPSGame
	attr_accessor :human, :computer
	attr_reader :score_limit

	def initialize(score_limit)
		@human = Human.new
		@computer = Computer.new
		@score_limit = score_limit
	end

	def display_welcome_message
		puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
		puts ""
	end

	def display_goodbye_message
		puts "Thanks for playing. Good bye!"
	end

	def display_moves
		puts "#{human.name} chose #{human.move}."
		puts "#{computer.name} chose #{computer.move}."
	end

	def display_round_winner
		if human.move > computer.move
			puts "#{human.name} won!"
			change_score(human)
		elsif human.move < computer.move
			puts "#{computer.name} won!"
			change_score(computer)
		else
			puts "It's a tie!"
		end
	end

	def play_again?
		answer = nil
		loop do
			puts "Would you like to play again? (y/n)"
			answer = gets.chomp
			break if ['y', 'n'].include?(answer.downcase)
		end

		return true if answer == 'y'
		return false if answer == 'n'
	end

	def change_score(player)
		player.score = player.score + 1
	end

	def display_score
		puts "#{human.name} score: #{human.score} | #{computer.name} score: #{computer.score}"
	end

	def score_limit_reached?
		human.score == score_limit || computer.score == score_limit
	end

	def display_winner
		puts "#{human.name} won the game! #{score_limit} points reached!" if human.score == score_limit
		puts "#{computer.name} won the game! #{score_limit} points reached!" if computer.score == score_limit
	end

	def reset_score
		human.score = 0
		computer.score = 0
	end

	def reset_history_of_moves
		human.history_of_moves = []
		computer.history_of_moves = []
	end

	def display_history_of_moves
		puts "#{human.name} moves so far: #{human.display_history_of_moves}"
		puts "#{computer.name} moves so far: #{computer.display_history_of_moves}"
	end

	def play
		display_welcome_message

		loop do
			display_history_of_moves unless human.history_of_moves.empty?
			puts ""
			human.choose
			computer.choose
			puts ""
			display_moves
			display_round_winner
			display_score
			puts ""
			if score_limit_reached?
				display_winner
				break unless play_again?
				reset_score 
				reset_history_of_moves
			end
		end

		puts ""
		display_goodbye_message
	end
end

RPSGame.new(3).play