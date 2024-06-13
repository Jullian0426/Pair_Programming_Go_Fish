# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :server, :client_states, :awaiting_state, :users

  def initialize
    @client_states = {}
    @awaiting_state = true
    @users = {}
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server&.close
  end

  def accept_new_client
    client = server.accept_nonblock
    client_states[client] = 'unnamed'
    puts 'Accepted client'
    client.puts('Enter your name: ')
    client
  rescue IO::WaitReadable, Errno::EINTR
    await_message_handler
  end

  def create_player_if_possble
    client_states.each do |client, state|
      next unless state == 'unnamed'

      name = capture_client_input(client)
      next if name.nil?

      client.puts('Enter your name: ') if name == ''

      create_player(client, name) unless name == ''
    end
  end

  private

  def create_player(client, name)
    client_states[client] = 'named'
    users[client] = Player.new(name)
  end

  def await_message_handler
    return if awaiting_state == false

    puts 'Awaiting clients'
    self.awaiting_state = false
  end

  def capture_client_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    nil
  end
end
