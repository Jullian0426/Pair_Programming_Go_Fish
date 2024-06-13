# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/player'
require_relative '../lib/card'

RSpec.describe Player do
  let(:player1) { Player.new('Player 1') }
  let(:card) { Card.new('2', 'H') }

  describe '#initialize' do
    it 'initializes with name and hand' do
      expect(player1.name).to eq 'Player 1'
      expect(player1).to respond_to :hand
    end
  end

  describe '#add_to_hand' do
    it 'should add card to hand array' do
      expect(player1.hand.dup).to eq []
      player1.add_to_hand(card)
      expect(player1.hand).to eq [card]
    end
  end
end
