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
  end

  describe '#make_cards' do
    it 'should fill cards array with appropriate number of elements' do
      expected_card_num = Card::SUITS.size * Card::RANKS.size * Game::DECK_MULTIPLIER
      expect(deck.cards.size).to eq expected_card_num
    end
  end

  describe '#shuffle' do
    it 'should shuffle the cards array' do
      unshuffled_cards = deck.cards.dup
      deck.shuffle(Random.new(1))
      expect(deck.cards).not_to eq unshuffled_cards
    end
  end
end
