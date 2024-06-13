# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'

# The Server class represents a socket server for the Go Fish card game.
class Server
  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server&.close
  end
end
