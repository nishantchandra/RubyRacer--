require_relative 'racer_utils'
require 'securerandom'
require 'colorize'

class RubyRacer
  attr_reader :players, :length
  attr_accessor :board

  def initialize(players, length)
    @players= []
    @board = []
    counter = 0
    while (counter < players)
      @players << SecureRandom.base64(1)[0]
      counter = counter + 1
    end    
    @length= length
    players.times do |x|
      @board << [@players[x]]+[""]*(@length-1)
    end  
    # @board=[[@players[0]]+[""]*(@length-1),[@players[1]]+[""]*(@length-1)]
    @orig_index=0
    @die_roll=0
    @winner=nil
  end
  
  # Returns +true+ if one of the players has reached 
  # the finish line, +false+ otherwise
  def finished?
    if winner 
      return true
    end
  end
  
  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @winner
  end
  
  # Rolls the dice and advances +player+ accordingly
  def advance_player!(index)
    die = Die.new

    @orig_index=board[index].index(@players[index])
    # p @orig_index #returns where player is
    @die_roll = die.roll #number of spaces to advance

    if @orig_index+@die_roll>=@length
      @winner = @players[index]

      board[index][@length-1] = board[index][@orig_index] # copying from orig to new
      board[index][@orig_index]=""
    else
      board[index][@orig_index+@die_roll] = board[index][@orig_index] # copying from orig to new
      board[index][@orig_index]=""
    end

  end
  
  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
     reputs('|')
     clear_screen!
     move_to_home!
    @players.each_with_index do |value,index|
      p board[index]
      puts
    end

  end
end

puts "How many players?"
input = gets.chomp.to_i
puts "How big is your track?"
track_size = gets.chomp.to_i



game = RubyRacer.new(input, track_size)

#p game.board

# until game.finished?
#   players.each_with_index do |players, index|
#     game.advance_player!(index)
#     p game.board
#   end
# end


# p game.finished?
# game.advance_player!(0)

# p game.board

# p game.finished?
# game.advance_player!(1)

# p game.board

# p game.finished?
# game.advance_player!(0)

# p game.board

# p game.finished?
# game.advance_player!(1)
 
# p game.board
# p game.finished?



# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
  input.times do |x|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!
  
    # We print the board first so we see the initial, starting board
    game.print_board
    game.advance_player!(x)
    
    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.4)
  end
end

# The game is over, so we need to print the "winning" board
# game.print_board

puts "Player '#{game.winner}' has won!".colorize( :blue )
