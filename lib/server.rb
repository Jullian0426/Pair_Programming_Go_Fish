# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :server, :client_states

  def initialize
    @client_states = {}
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
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No Client to Accept'
  end
end
