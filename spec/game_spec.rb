# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'

RSpec.describe Game do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:game) { Game.new([player1, player2]) }

  describe '#initialize' do
    it 'should respond to players' do
      expect(game).to respond_to :players
      expect(game).to respond_to :deck
    end
  end

  describe 'start' do
    it 'should prompt deck to shuffle' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end

    it 'should prompt deck to remove cards and player to add cards' do
      expect(game.deck).to receive(:deal).at_least(:once)
      expect(player1).to receive(:add_to_hand).at_least(:once)
      expect(player2).to receive(:add_to_hand).at_least(:once)
      game.start
    end

    it 'should deal cards to players' do
      starting_deck_size = game.deck.cards.size.dup
      expected_deck_size = starting_deck_size - game.players.size * Game::STARTING_HAND_SIZE
      game.start
      expect(game.deck.cards.size).to eq expected_deck_size
      expect(player1.hand.size).to eq Game::STARTING_HAND_SIZE
      expect(player2.hand.size).to eq Game::STARTING_HAND_SIZE
    end
  end
end
