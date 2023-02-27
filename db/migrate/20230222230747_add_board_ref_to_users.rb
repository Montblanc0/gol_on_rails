class AddBoardRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :board, null: true, foreign_key: true
  end
end
