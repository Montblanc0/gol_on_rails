# frozen_string_literal: true

# Class that represents the game board
# It stores a size and the actual table
# Creates next generations, updates cells and turns hashes to tables
class Table
  attr_reader :size, :table

  def initialize(size)
    raise 'Error generating board: size must be an integer' unless size.is_a?(Integer)

    @size = size
    setup_table
  end

  # Turns a parsed JSON string into a Table instance
  def self.table_factory(blueprint)
    table = Table.new blueprint['size']
    blueprint['table'].each_with_index do |row, i|
      row.each_with_index do |column, j|
        if column['alive'] == 1
          table[i, j].resurrect
        else
          table[i, j].die
        end
      end
    end
    table
  end

  def [](row, col)
    @table[row][col]
  end

  # Creates the next generation by applying the game logics
  def apply_rules
    next_gen = Table.new @size
    @size.times do |row|
      @size.times do |column|
        cell = self[row, column]
        next_gen_cell = next_gen.table[row][column]
        neighbours = neighbours(cell)
        if !cell.alive? && neighbours == 3
          # If cell is dead, and alive neighbours are exactly 3, resurrect
          next_gen_cell.resurrect

        elsif cell.alive? && [2, 3].include?(neighbours)
          # If cell is alive, and its alive neighbours are exactly 2 or 3, it survives
          next_gen_cell.resurrect
        else
          # Else it dies
          next_gen_cell.die
        end
      end
    end
    @table = next_gen.table
    self
  end

  # Kills every cell
  def clear
    @size.times do |row|
      @size.times do |column|
        @table[row][column].die
      end
    end
    self
  end

  private

  # Generates a new table and initializes cells
  def setup_table
    @table = []
    @size.times do |row|
      @table[row] = []
      @size.times do |column|
        @table[row][column] = Cell.new(row, column)
      end
    end
  end

  # Calculates alive neighbours count
  def neighbours(cell)
    neighbours = []
    # Adds pac-man effect when out of bounds
    x_minus = (cell.x - 1) <= -1 ? (@table.size - 1) : (cell.x - 1)
    y_minus = (cell.y - 1) <= -1 ? (@table.size - 1) : (cell.y - 1)
    x_plus = (cell.x + 1) >= @table.size ? 0 : (cell.x + 1)
    y_plus = (cell.y + 1) >= @table.size ? 0 : (cell.y + 1)
    # top-left
    neighbours.push(@table[x_minus][y_minus])
    # left
    neighbours.push(@table[x_minus][cell.y])
    # bottom-left
    neighbours.push(@table[x_minus][y_plus])
    # top
    neighbours.push(@table[cell.x][y_minus])
    # bottom
    neighbours.push(@table[cell.x][y_plus])
    # top-right
    neighbours.push(@table[x_plus][y_minus])
    # right
    neighbours.push(@table[x_plus][cell.y])
    # bottom-right
    neighbours.push(@table[x_plus][y_plus])
    # filter alive cells only
    neighbours.select! { |n| n.alive? }
    # return alive neighbours count
    neighbours.size
  end
end
