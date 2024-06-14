# frozen_string_literal: true

# Represents a player of the game
class Player
  attr_reader :name
  attr_accessor :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def add_to_hand(card)
    hand << card
  end

  def hand_has_rank?(rank)
    hand.any? { |card| card.rank == rank }
  end
end
