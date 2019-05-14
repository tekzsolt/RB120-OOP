class Card
  include Comparable
  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(@rank, @rank) #if value can't be found it returns the @rank (hence second argument)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end


class Deck
	attr_accessor :deck

  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
  	@deck = []
  	create_deck
  end

  def draw
  	create_deck if deck.size == 0
  	deck.pop
  end

  private

  def create_deck
  	RANKS.each do |rank|
  		SUITS.each do |suit|
  			self.deck << Card.new(rank, suit)
  		end
  	end
  	deck.shuffle!
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
