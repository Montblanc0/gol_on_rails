class GolController < ApplicationController
  include GolHelper
  before_action :authenticate_user!
  before_action :set_user_board, except: %i[stall update_cell]
  rescue_from StandardError, with: :catch_errors

  # Apply the rules and create the next-generation
  # If a stalling situation occurs, redirect
  def next_gen
    @table = read_table
    current_gen = read_table
    next_gen = @table.apply_rules

    if stall?(current_gen, next_gen)
      msg = 'Iterations stopped. It seemed you have reached a stall. Try editing some cells or generate a new random board.'
      flash[:alert] = msg
      redirect_to '/gol', status: 303
    else
      @board.gen += 1
      @board.save!
      write_table(@table)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('turbo_gol', partial: 'table', locals: { table: @table }),
            turbo_stream.update('current_gen', plain: @board.gen)
          ]
        end
        format.html { render 'gol/gol' }
      end
    end
  end

  # Toggles the state of a single cell
  def update_cell
    x = cell_params[:x].to_i
    y = cell_params[:y].to_i
    @table = read_table
    cell = @table[x, y]
    cell.alive? ? cell.die : cell.resurrect
    write_table(@table)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update('turbo_gol', partial: 'table', locals: { table: @table })
      end
      format.html { render 'gol/gol' }
    end
  end

  # Initializes a new board with the specified size
  def generate
    validate_size(table_params)
    @board.gen = 1
    @board.size = table_params.to_i
    @board.save!
    @table = Table.new @board.size
    write_table(@table)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('turbo_gol', partial: 'table', locals: { table: @table }),
          turbo_stream.update('current_gen', plain: @board.gen)
        ]
      end
      format.html { redirect_to '/gol' }
    end
  end

  # Exports the current state of the board to JSON
  def export
    @table = read_table
    filename = "table_#{DateTime.now.strftime('%Y%m%d%H%M%S')}.json"
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    respond_to do |format|
      format.json { render json: { table: @table, gen: @board.gen }.to_json }
    end
  end

  # Reads a JSON, validates it and restores board state
  def import
    json = params[:file].read
    parsed_json = JSON.parse(json)
    JsonValidator.validate_json(parsed_json)
    @board.size = parsed_json['table']['size']
    @board.gen = parsed_json['gen']
    @table = Table.table_factory(parsed_json['table'])
    @board.save!
    write_table(@table)
    redirect_to gol_path
  end

  def gol
    @table = read_table
    render 'gol/gol'
  end

  # Clears the board by killing every cell and resets generation
  def clear
    @table = Table.new(@board.size)
    write_table(@table.clear)
    @board.gen = 1
    @board.save!
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('turbo_gol', partial: 'table', locals: { table: @table }),
          turbo_stream.update('current_gen', plain: @board.gen)
        ]
      end
      format.html { redirect_to '/gol' }
    end
  end

  # Redirects to gol#gol and displays an alert (AJAX redirect)
  def stall
    redirect_to '/gol',
                alert: 'Iterations stopped. It seemed you have reached a stall. Try editing some cells or generate a new random board.'
  end

  private

  def set_user_board
    @board = current_user.board
  end

  def validate_size(size)
    raise 'Must be a number from 10 to 40' unless size.to_i >= 10 && size.to_i <= 40
  end

  # checks whether next generation would be the same
  # only checks for still life and empty tables
  # (does not account for oscillators and such )
  def stall?(current_gen, next_gen)
    current_gen.to_json == next_gen.to_json
  end
end
