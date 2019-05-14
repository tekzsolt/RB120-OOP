class Card
  include Comparable
  attr_reader :rank, :suit

  RANKS = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    RANKS.fetch(@rank, @rank) #if value can't be found it returns the @rank (hence second argument)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end # end of class Card


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
end # end of class Deck


class PokerHand
  attr_reader :hand

  def initialize(deck)
    @hand = []
    5.times do 
      @hand << deck.draw
    end
  end

  def print
    hand.each do |card|
      puts card
    end
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    temp_card_values = []
    temp_card_suits = []
    hand.each do |card|
      temp_card_values << card.value
      temp_card_suits << card.suit
    end

    return false if temp_card_values.sort != [10, 11, 12, 13, 14]

    Deck::SUITS.each do |suit|
      return true if temp_card_suits.count(suit) == 5
    end

    false
  end

  def straight_flush?
    temp_card_values = []
    temp_card_suits = []
    hand.each do |card|
      temp_card_values << card.value
      temp_card_suits << card.suit
    end

    temp_card_values.sort!
    return false if temp_card_values.last - temp_card_values.first != 4 && temp_card_values.last - temp_card_values[1] != 3 # consecutive 5 values

    Deck::SUITS.each do |suit|
      return true if temp_card_suits.count(suit) == 5
    end
    
    false
  end

  def four_of_a_kind?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    Deck::RANKS.each do |value|
      return true if temp_card_values.count(value) == 4
    end

    false
  end

  def full_house?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    result = []
    Deck::RANKS.each do |value|
      nr = temp_card_values.count(value)
      result << nr unless nr == 0
    end

    result.sort == [2,3]
  end

  def flush?
    temp_card_suits = []
    hand.each do |card|
      temp_card_suits << card.suit
    end

    Deck::SUITS.each do |suit|
      return true if temp_card_suits.count(suit) == 5
    end

    false
  end

  def straight?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    temp_card_values.sort!
    temp_card_values.last - temp_card_values.first == 4 && temp_card_values.last - temp_card_values[1] == 3 # consecutive 5 values
  end

  def three_of_a_kind?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    Deck::RANKS.each do |value|
      return true if temp_card_values.count(value) == 3
    end

    false
  end

  def two_pair?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    result = []
    Deck::RANKS.each do |value|
      result << 2 if temp_card_values.count(value) == 2
    end

    result.count(2) == 2
  end

  def pair?
    temp_card_values = []
    hand.each do |card|
      temp_card_values << card.value
    end

    result = []
    Deck::RANKS.each do |value|
      result << temp_card_values.count(value) if temp_card_values.count(value) == 2
    end

    result.count(2) == 1
  end
end # end of class PokerHand


hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# # Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'

# Expected Output:
# <--- START ---> between START and END output might vary
# 5 of Clubs
# 7 of Diamonds
# Ace of Hearts
# 7 of Clubs
# 5 of Spades

# Two pair
# <--- END --->
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true