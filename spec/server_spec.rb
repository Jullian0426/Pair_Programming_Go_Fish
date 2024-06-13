# frozen_string_literal: true

require 'spec_helper'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/client'

RSpec.describe Server do
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

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  def make_client
    client = Client.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
  end

  describe '#accept_new_client' do
    it 'adds client to accepted_clients array and sends accepted message' do
      expect(@server.client_states.empty?).to eq true
      server_client = make_client
      expect(@server.client_states[server_client]).to eq Client::STATES[:unnamed]
      expect { make_client }.to output("Accepted client\n").to_stdout
    end

    it 'sends message only once when server is waiting to accept clients' do
      expect { @server.accept_new_client }.to output("Awaiting clients\n").to_stdout
      @server.accept_new_client
      expect { @server.accept_new_client }.not_to output("Awaiting clients\n").to_stdout
    end
  end

  describe '#create_player_if_possble' do
    it 'should update client state to named if name is provided' do
      server_client = make_client
      expect(@server.client_states[server_client]).to eq Client::STATES[:unnamed]
      @clients.first.provide_input('Player 1')
      @server.create_player_if_possible
      expect(@server.client_states[server_client]).to eq Client::STATES[:named]
    end

    it 'should associate client to new player if client is named' do
      make_client
      @clients.first.provide_input('Player 1')
      expect(@server.users.empty?).to eq true
      @server.create_player_if_possible
      expect(@server.users.empty?).to eq false
    end
  end

  describe '#create_game_if_possible' do
    it '' do
    end
  end
end
