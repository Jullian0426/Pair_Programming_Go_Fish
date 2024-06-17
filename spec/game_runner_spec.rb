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
      expect(runner).to receive(:validate_choices).ordered
      expect(game).to receive(:play_round).ordered
      expect(runner).to receive(:display_round_result).ordered
      runner.run_loop
    end
  end

  describe '#display_hand' do
    it 'should send current player a display of their hand' do
      game.start
      runner.display_hand
      expect(@clients.first.capture_output).to match(/Your hand: (\d+[HCDS],\s)*\d+[HCDS]/)
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

  describe '#validate_choices' do
    before do
      game.current_player.add_to_hand(card1)
    end
    it 'prompts the user to input rank if both choices are nil' do
      runner.validate_choices
      expect(@clients[0].capture_output).to include('Choose a rank to ask for: ')
    end
    it 'prompts the user once to input rank if both choices are nil' do
      runner.validate_choices
      expect(@clients[0].capture_output).to include('Choose a rank to ask for: ')
      runner.validate_choices
      expect(@clients[0].capture_output).not_to include('Choose a rank to ask for: ')
    end
    it 'resets the choice rank to nil if it is invalid' do
      @clients[0].provide_input('4')
      runner.receive_choices
      runner.validate_choices
      expect(runner.choices[:rank]).to be nil
    end
    it 'resets the choice opponent to nil if it is invalid' do
      @clients[0].provide_input('3')
      runner.receive_choices
      @clients[0].provide_input('Larry Boy')
      runner.receive_choices
      runner.validate_choices
      expect(runner.choices[:opponent]).to be nil
    end
    it 'sets the choice rank if input is valid' do
      @clients[0].provide_input('3')
      runner.receive_choices
      runner.validate_choices
      expect(runner.choices[:rank]).to eql '3'
    end
    it 'sets the choice opponent if input is valid' do
      @clients[0].provide_input('3')
      runner.receive_choices
      @clients[0].provide_input('1')
      runner.receive_choices
      runner.validate_choices
      expect(runner.choices[:rank]).to eq '3'
      expect(runner.choices[:opponent]).to eq '1'
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
