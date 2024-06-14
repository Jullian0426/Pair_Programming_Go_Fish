# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game_runner'
require_relative '../lib/server'
require_relative '../lib/client'
require_relative '../lib/game'
require_relative '../lib/card'

RSpec.describe GameRunner do
  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  before do
    make_client_and_player(0)
    make_client_and_player(1)
  end

  let(:game) { @server.create_game_if_possible }
  let(:runner) { GameRunner.new(game, @server.users.keys) }
  let(:card1) { Card.new('3', 'H') }
  let(:card2) { Card.new('6', 'C') }

  # TODO: ask about testing helper methods and loops
  describe '#run' do
    it 'should start a game' do
      expect(game).to receive(:start).once
      game.winner = game.current_player
      runner.run
    end
  end

  describe '#run_loop' do
    it 'should call methods necessary for one round' do
      expect(game).to receive(:deal_empty_hands).ordered
      expect(runner).to receive(:display_hand).ordered
      expect(runner).to receive(:receive_choices).ordered
      expect(game).to receive(:play_round).ordered
      expect(runner).to receive(:display_round_result).ordered
      runner.run_loop
    end
  end

  # TODO: ask if logic in the test like this is best practice
  describe '#display_hand' do
    it 'should send current player a display of their hand' do
      game.start
      runner.display_hand
      card_list = game.current_player.hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ').to_s
      expect(@clients.first.capture_output).to include("Your hand: #{card_list}")
    end
  end

  describe '#receive_choices' do
    before do
      @clients[0].provide_input('3')
      runner.receive_choices
    end
    it 'sets rank choice equal to client input if rank is nil' do
      expect(runner.choices).to eq({ rank: '3', opponent: nil })
    end

    it 'sets opponent choice equal to client input if rank is set and opponent is nil' do
      @clients[0].provide_input('2')
      runner.receive_choices
      expect(runner.choices).to eq({ rank: '3', opponent: '2' })
    end
  end

  def make_client_and_player(index)
    client = Client.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    @clients[index].provide_input("Player #{index + 1}")
    @server.create_player_if_possible
  end
end
