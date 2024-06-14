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
    game.draw_empty_hands
    display_hand
    get_choices
    game.play_round
    display_round_result
  end

  def display_hand
    card_list = game.current_player.hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ').to_s
    client = find_client_for_player(game.current_player)
    client.puts("Your hand: #{card_list}")
  end

  def get_choices
    { rank: '3', opponent: '2' }
  end

  def display_round_result
  end

  private

  def find_client_for_player(player)
    index = game.players.index(player)
    @clients[index]
  end
end
