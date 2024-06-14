# frozen_string_literal: true

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_reader :game, :clients
  attr_accessor :choices, :current_client

  def initialize(game, clients)
    @game = game
    @clients = clients
    @choices = { rank: nil, opponent: nil }
    @current_client = find_client_for_player(game.current_player)
  end

  def run
    game.start
    run_loop unless game.winner
  end

  def run_loop
    game.deal_empty_hands
    display_hand
    receive_choices
    validate_choices
    game.play_round
    display_round_result
  end

  def display_hand
    card_list = game.current_player.hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ').to_s
    current_client.puts("Your hand: #{card_list}")
  end

  def receive_choices
    input = capture_client_input(current_client)
    if choices[:rank].nil?
      choices[:rank] = input
    elsif choices[:opponent].nil?
      choices[:opponent] = input
    end
    nil
  end

  def validate_choices
    return current_client.puts('Choose a rank to ask for: ') if choices[:rank].nil?

    player_has_rank = game.current_player.hand_has_rank?(choices[:rank])
    if !player_has_rank
      choices[:rank] = nil
    elsif choices[:opponent].to_i <= 0 || !game.players[choices[:opponent].to_i - 1]
      choices[:opponent] = nil
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
    nil
  end
end
