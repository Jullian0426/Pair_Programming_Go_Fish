# frozen_string_literal: true

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_reader :game, :clients

  def initialize(game, clients)
    @game = game
    @clients = clients
  end

  def run
    game.start
    run_loop unless game.winner
  end

  def run_loop
    
  end
end
