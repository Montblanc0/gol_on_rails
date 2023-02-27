# frozen_string_literal: true

# Class used to represent a Cell
# It stores x and y positions and alive status
class Cell
  attr_accessor :alive
  attr_reader :x, :y

  def initialize(x, y)
    @alive = rand(0..1)
    @x = x
    @y = y
  end

  def die
    @alive = 0
  end

  def resurrect
    @alive = 1
  end

  def alive?
    return true if @alive == 1

    false
  end

  def inspect
    @alive
  end
end
