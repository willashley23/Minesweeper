class Tile
  require_relative 'player'
  require_relative 'board'

  def initialize(value = 0)
    @has_bomb = false
    @value = value
    @flag = false
    @revealed = false
  end

  attr_accessor :has_bomb, :flag, :revealed, :value
end
