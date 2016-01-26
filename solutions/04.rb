SUITES = [:spades, :hearts, :diamonds, :clubs]
RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
BELOTE_RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]
SIXTY_SIX_RANKS = [9, :jack, :queen, :king, 10, :ace]


class Card
  include Comparable

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    @rank.to_s.capitalize + " of " + @suit.to_s.capitalize
  end

  def ==(other)
    other.class == self.class && other.suit == @suit && other.rank == @rank
  end

  attr_reader :suit, :rank
end

class Hand
  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.size
  end

  def to_s
    @cards.join("\n")
  end

  attr_reader :cards
  protected
  def some_suite_contains_ranks?(ranks, suites)
    suites.any? {|suit| suite_contains_ranks(suit, ranks)}
  end

  private
  def suite_contains_ranks(suit, ranks)
    cards_of_suit = @cards.select {|card| card.suit == suit}

    ranks.all? {|rank| cards_of_suit.any? {|card| card.rank == rank}}
  end
end

class WarHand < Hand
  def play_card
    @cards.delete_at(rand(@cards.size))
  end

  def allow_face_up?
    @cards.size <= 3
  end
end

class BeloteHand < Hand
  def highest_of_suit(suit)
    cards_of_suit = @cards.select {|card| card.suit == suit}
    cards_of_suit.max {
      |a,b| BELOTE_RANKS.find_index(a) <=> BELOTE_RANKS.find_index(b)
    }
  end

  def belote?
    some_suite_contains_ranks?([:queen, :king], SUITES)
  end

  def tierce?
    sequence_of_ranks?(3)
  end

  def quarte?
    sequence_of_ranks?(4)
  end

  def quint?
    sequence_of_ranks?(5)
  end

  def carre_of_jacks?
    four_of_kind(:jack)
  end

  def carre_of_nines?
    four_of_kind(9)
  end

  def carre_of_aces?
    four_of_kind(:ace)
  end

  private
  def sequence_of_ranks?(length)
    RANKS.each_cons(length).any? do |rank_cons|
      some_suite_contains_ranks?(rank_cons, SUITES)
    end
  end

  def four_of_kind(rank)
    number_of_kind = @cards.count {|card| card.rank == rank}
    number_of_kind == 4
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    suites = SUITES.select {|suit| suit != trump_suit}

    some_suite_contains_ranks?([:queen, :king], suites)
  end

  def forty?(trump_suit)
    some_suite_contains_ranks?([:queen, :king], [trump_suit])
  end
end


class Deck
  include Enumerable

  def initialize(cards = nil)
    if (cards)
      @cards = cards
    else
      @cards = SUITES.product(ranks_order).map do |suit, rank|
        Card.new(rank, suit)
      end
    end
  end

  def each
    @cards.each { |card| yield card }
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort! {|x, y| compare_cards(x, y)}
  end

  def deal
    get_hand(get_hand_size.times.collect { draw_top_card() })
  end

  def to_s
    @cards.join("\n")
  end

  protected
  def get_hand_size
    1
  end
  def get_hand(cards)
    Hand.new(cards)
  end

  def compare_cards(card, other_card)
    ranks = ranks_order

    card_suit_value = SUITES.find_index(card.suit)
    other_card_suit_value = SUITES.find_index(other_card.suit)

    card_rank_value = ranks.find_index(card.rank)
    other_rank_suit_value = ranks.find_index(other_card.rank)

    suit_diff = other_card_suit_value - card_suit_value
    rank_diff = other_rank_suit_value - card_rank_value
    suit_diff != 0 ? suit_diff : rank_diff
  end

  def ranks_order
    RANKS.clone
  end
end

class WarDeck < Deck
  protected
  def get_hand_size
    return 26
  end

  def get_hand(cards)
    WarHand.new(cards)
  end
end

class BeloteDeck < Deck
  protected
  def get_hand_size
    return 8
  end

  def get_hand(cards)
    BeloteHand.new(cards)
  end

  def ranks_order
    BELOTE_RANKS.clone
  end
end

class SixtySixDeck < Deck
  protected
  def get_hand_size
    return 6
  end

  def get_hand(cards)
    SixtySixHand.new(cards)
  end

  def ranks_order
    SIXTY_SIX_RANKS.clone
  end
end
