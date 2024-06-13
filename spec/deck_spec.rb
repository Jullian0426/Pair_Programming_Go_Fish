# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/deck'
require_relative '../lib/card'

RSpec.describe Deck do
  let(:deck) { Deck.new([]) }

  describe '#initialize' do
    it 'initializes with cards' do
      expect(deck).to respond_to :cards
    end
  end

  before do
    deck.cards = deck.make_cards
    @starting_deck_size = Card::SUITS.size * Card::RANKS.size * Game::DECK_MULTIPLIER
  end

  describe '#make_cards' do
    it 'should fill cards array with appropriate number of elements' do
      expect(deck.cards.size).to eq @starting_deck_size
    end
  end

  describe '#shuffle' do
    it 'should shuffle the cards array' do
      unshuffled_cards = deck.cards.dup
      deck.shuffle(Random.new(1))
      expect(deck.cards).not_to eq unshuffled_cards
    end
  end

  describe '#deal' do
    it 'should remove the top card' do
      dealt_card = deck.deal
      expect(dealt_card).to respond_to :rank
      expect(deck.cards.size).to eq @starting_deck_size - 1
    end
  end
end
