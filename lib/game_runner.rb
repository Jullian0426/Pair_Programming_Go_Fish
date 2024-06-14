# frozen_string_literal: true

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_reader :game, :clients
  attr_accessor :choices

  def initialize(game, clients)
    @game = game
    @clients = clients
    @choices = { rank: nil, opponent: nil }
  end

  def run
    game.start
    run_loop unless game.winner
  end

  def run_loop
    game.deal_empty_hands
    display_hand
    receive_choices
    game.play_round
    display_round_result
  end

  def display_hand
    card_list = game.current_player.hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ').to_s
    client = find_client_for_player(game.current_player)
    client.puts("Your hand: #{card_list}")
  end

  def receive_choices
    client = find_client_for_player(game.current_player)
    input = capture_client_input(client)
    if @choices[:rank].nil?
      @choices[:rank] = input
    elsif @choices[:opponent].nil?
      @choices[:opponent] = input
    end
  end

  def display_round_result
  end

  private

  def find_client_for_player(player)
    index = game.players.index(player)
    @clients[index]
  end

  def capture_client_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp.upcase
  rescue IO::WaitReadable
    @output = ''
  end
end
