# frozen_string_literal: true

require_relative 'deck'

# Represents the game of Go Fish
class Game
  attr_reader :players
  attr_accessor :winner, :current_player

  DECK_MULTIPLIER = 1
  STARTING_HAND_SIZE = 5
  MIN_PLAYERS = 2

  def initialize(players)
    @players = players
    @winner = winner
    @current_player = players.first
  end

  def deck
    @deck ||= Deck.new
  end

  def start
    deck.shuffle

    STARTING_HAND_SIZE.times do
      players.each { |player| player.add_to_hand(deck.deal) }
    end
  end

  def draw_empty_hands
    players.each do |player|
      STARTING_HAND_SIZE.times { player.add_to_hand(deck.deal) } if player.hand.empty?
    end
  end

  def play_round
  end
end
