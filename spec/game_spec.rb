# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'

RSpec.describe Game do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:game) { Game.new([player1, player2]) }

  describe '#initialize' do
    it 'should initialize with player objects' do
      expect(game).to respond_to :players
    end
  end

  describe 'start' do
    it 'should prompt deck to shuffle' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end
  end
end
