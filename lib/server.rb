# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'
require_relative 'game_runner'
require_relative 'client'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :server, :client_states, :awaiting_state, :users, :games

  def initialize
    @client_states = {}
    @awaiting_state = true
    @users = {}
    @games = []
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
    client_states[client] = Client::STATES[:unnamed]
    puts 'Accepted client'
    client.puts('Enter your name: ')
    client
  rescue IO::WaitReadable, Errno::EINTR
    await_message_handler
  end

  def create_player_if_possible
    client_states.each do |client, state|
      next unless state == Client::STATES[:unnamed]

      name = name_handler(client)
      create_player(client, name) unless name.nil?
    end
  end

  def name_handler(client)
    name = capture_client_input(client)
    return name if name.nil?

    return name unless name.empty?

    client.puts('Invalid Input: ')
    nil
  end

  def create_game_if_possible
    return if users.size < Game::MIN_PLAYERS

    game = Game.new(users.values)
    games << game
    game
  end

  def run_game(game)
    clients = game.players.map { |player| users.key(player) }
    runner = GameRunner.new(game, clients)
    runner.run
  end

  private

  def create_player(client, name)
    client_states[client] = Client::STATES[:named]
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
