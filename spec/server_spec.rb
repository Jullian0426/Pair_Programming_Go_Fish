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
      expect(@server.client_states[server_client]).to eq 'unnamed'
      expect { make_client }.to output("Accepted client\n").to_stdout
    end

    it 'sends message when no clients exist that have not been accepted' do
      expect { @server.accept_new_client }.to output("No Client to Accept\n").to_stdout
    end
  end
end
