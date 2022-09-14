#!/usr/bin/env ruby

X = 1
O = -1

PLAYER_TO_NAME = {
  -1 => "O",
  1 =>  "X"
}

NAME_TO_PLAYER = PLAYER_TO_NAME.invert

class InvalidMoveError < StandardError; end
class AlreadyTakenError < StandardError; end

class Board

  def initialize
    @storage = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  end

  def game_over?
    winner != nil || full?
  end

  def winner
    lines.each do |line|
      sum = @storage.values_at(*line).sum

      if sum == 3
        return X
      elsif sum == -3
        return O
      end
    end

    nil
  end

  def full?
    @storage.none?(0)
  end

  def make_move(player, move)
    idx = move - 1

    if idx < 0 || idx > 8
      raise InvalidMoveError
    elsif @storage[idx] != 0
      raise AlreadyTakenError
    end

    @storage[idx] = player
  end

  def lines
    [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],

      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 7],

      [0, 4, 8],
      [2, 4, 6],
    ]
  end

  def to_s
    <<~END
    #{b(0)} #{b(1)} #{b(2)}
    #{b(3)} #{b(4)} #{b(5)}
    #{b(6)} #{b(7)} #{b(8)}
    END
  end

  private

  def b(idx)
    PLAYER_TO_NAME[@storage[idx]] || idx+1
  end
end

board = Board.new
player = X

until board.game_over?
  puts board
  puts

  loop do
    print "#{PLAYER_TO_NAME[player]}’s turn. Enter move: "

    input = gets.chomp
    move = input.to_i

    begin
      board.make_move(player, move)
      puts
      break
    rescue InvalidMoveError => e
      puts
      puts "`#{input}' is not a valid move. Please try again."
      puts
    rescue AlreadyTakenError => e
      puts
      puts "#{move} is already taken. Please pick another space."
      puts
    end
  end

  player *= -1
end

winner = board.winner

puts board
puts

if winner
  puts "#{PLAYER_TO_NAME[winner]} won!"
else
  puts "It's a tie."
end
