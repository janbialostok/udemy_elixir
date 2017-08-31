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

  def save do 
    
  end

  def load do
    
  end

end
