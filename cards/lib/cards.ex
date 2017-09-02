defmodule Cards do
  
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
    # naive solution for generating the cards non-optimal because uses intermediate computation
    # cards = for suit <- suits do
      # for value <- values do
        # "#{ value } of #{ suit }"
      # end
    # end
    # List.flatten(cards)
    for suit <- suits, value <- values do
      "#{ value } of #{ suit }"
    end
  end

  def shuffle(deck) do 
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
  # use pattern matching to retrieve values from returned tuple
  # { hand, deck } = deal(Cards.create_deck, 5)
  def deal(deck, size) do
    Enum.split(deck, size)
  end

  def save(deck, filename) do 
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # you can multi-line case statements
    case File.read(filename) do
      # case statements will return a value allowing you to execute pattern matching assignments. Additionally match errors will be treated as falsy statements
      { :ok, binary } -> :erlang.binary_to_term(binary)
      # _ preceeding a variable declaration denotes a variable declaration that will not be used
      { :error, _reason } -> "That file does not exist"
    end
  end

  def create_hand(size) do
    # naive code not using pipe operator
    # deck = Cards.create_deck
    # deck = Cards.shuffle(deck)
    # hand = Cards.deal(deck, size)
    # pipe operator injects return value from subsequent evaluation as first argument in preceeding function
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(size)
  end

end

