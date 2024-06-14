# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game_runner'
require_relative '../lib/server'
require_relative '../lib/client'

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
    @game = @server.create_game_if_possible
  end

  let(:runner) { GameRunner.new(@game, @server.users.keys) }

  describe '#run' do
    it 'should start a game' do
      expect(@game).to receive(:start).once
      runner.run
    end
  end

  describe '#run_loop' do
    it 'should call methods necessary for one round' do
      expect(@game).to receive(:draw_empty_hands)
      expect(runner).to receive(:display_hand)
      expect(runner).to receive(:get_choices)
      expect(@game).to receive(:play_round)
      expect(runner).to receive(:display_round_result)
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
