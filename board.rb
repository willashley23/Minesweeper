
class Board
require_relative 'tile'
require_relative 'player'
require 'byebug'

def initialize
  @grid = Array.new(8) do
    Array.new(8) { Tile.new(0) }
  end
  add_bombs
  @bomb_locations = []
  find_bombs
  set_values(@bomb_locations)
end

def add_bombs(num_bombs = 10)
  until @grid.flatten.count {|x| x.has_bomb == true} == num_bombs
    grid.sample.sample.has_bomb = true
  end
end

def find_bombs
  locations = []
  @grid.each_with_index do |row, index|
    row.each_with_index do |col, index2|
      locations << [index, index2] if col.has_bomb
    end
  end
  @bomb_locations = locations
end

def set_values(locations)
  @grid.each_with_index do |row, x|
    row.each_with_index do |col, y|
      pos = []
      if y < @grid.count && x < @grid.count
        pos = adjacent_spaces(x,y)
      end
      col.value = @bomb_locations.count {|x| pos.include? x}
    end
  end
end

def adjacent_spaces(x,y)
  [[x,y+1],[x+1, y] , [x+1, y+1] , [x-1, y-1] , [x-1, y+1] , [x+1, y-1] , [x, y - 1] , [x - 1, y]]
end

def game_over?
  @grid.each do |row|
    row.each do |col|
      if col.revealed && col.has_bomb
        puts "You clicked a bomb, game over!"
        return true
      end
      return false unless col.revealed && col.has_bomb
    end
  end
  puts "you win!"
  return true
end

def play_game
  until game_over?
    system('clear')
    render
    puts "choose a tile (i.e. '3,4')"
    guess = gets.chomp.split(',').map(&:to_i)
    puts "you wanna flag that or excavate it (1 or 0)"
    choice = gets.to_i
    case choice
    when 1
      set_flag(guess)
    when 0
      bombed = uncover(guess)
      break if bombed
    end
  end
end



def set_flag(pos)
  @grid[pos[0]][pos[1]].flag = true
end

def uncover(pos)
  if @grid[pos[0]][pos[1]].has_bomb
    system('clear')
    reveal_board
    puts "FIRE IN THE HOLE!!!"
    return true
  else
    @grid[pos[0]][pos[1]].revealed = true
    return false
  end
end



def reveal_board
  @grid.each do |row|
    row.each do |col|
      if col.has_bomb
        print "[💣]"
      else
        print "[#{col.value}]"
      end
    end
    puts ""
  end
end


def render
  (0..7).to_a.each{|n| print " #{n} "}
  puts ""
  @grid.each do |row|
    row.each do |col|
      if !col.revealed && col.flag == false
        print '[ ]'
      elsif col.flag
        print "[⚑]"
      elsif !col.has_bomb && col.revealed
        print "[#{col.value}]"
      end
    end
    puts ""
  end
end
attr_accessor :grid
end

b = Board.new
g = b.grid
b.play_game
