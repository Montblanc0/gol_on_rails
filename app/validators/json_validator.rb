# frozen_string_literal: true

# An utility class used to perform validations on imported JSONs
class JsonValidator
  # Main method that expects a parsed JSON file
  # Performs basic validations
  # When all basic validations pass, invokes #validate_table
  def self.validate_json(parsed_json)
    raise "Invalid JSON: keys must be 'gen' and 'table'" unless parsed_json.keys.sort == %w[gen table]

    @@gen = parsed_json['gen']
    @@table = parsed_json['table']

    unless @@gen.is_a?(Integer) && @@table['size'].is_a?(Integer)
      raise "Invalid JSON: 'size' and 'gen' values must be integers"
    end

    raise "Invalid JSON: 'size' must be >= 10 and <= 40" unless @@table['size'] >= 10 && @@table['size'] <= 40

    raise "Invalid JSON: 'gen' must be >= 1" unless @@gen >= 1

    validate_table

    true
  end

  # Checks for rows count and column count
  # Invokes #validate_cells on every cell
  def self.validate_table
    size = @@table['size']
    raise 'Invalid JSON: rows count does not match expected size' unless size == @@table['table'].size

    size.times do |row|
      raise 'Invalid JSON: columns count does not match expected size' unless size == @@table['table'][row].size

      size.times do |column|
        validate_cells(row, column)
      end
    end
  end

  # Checks for cell keys and values
  def self.validate_cells(row, column)
    cell = @@table['table'][row][column]

    raise "Invalid JSON: cell keys must be 'alive', 'x' and 'y'" unless cell.keys.sort == %w[alive x y]

    raise 'Invalid JSON: invalid cell rows' unless row == cell['x']
    raise 'Invalid JSON: invalid cell columns' unless column == cell['y']
    raise 'Invalid JSON: invalid alive status' unless [0, 1].include?(cell['alive'])
  end
end
