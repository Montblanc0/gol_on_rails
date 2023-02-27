module GolHelper
  def table_params
    params.require(:size)
  end

  def board_params
    params.require(:board).permit(:size, :gen)
  end

  def cell_params
    params.require(:cell).permit(:x, :y, :alive)
  end

  def write_table(table)
    $redis.set("table_#{current_user.id}", table.to_json, ex: 86400) # expire in 1 day
  end

  def read_table
    Table.table_factory(JSON.parse($redis.get("table_#{current_user.id}")))
  end

  def catch_errors(error = nil)
    redirect_to root_path, alert: error ? error.message : 'An error occurred.'
    return unless error

    backtrace = error&.backtrace&.join("\n")
    Rails.logger.error("#{error.message}\n#{backtrace}")
  end

end
