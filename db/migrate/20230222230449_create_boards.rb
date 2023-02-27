class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.integer :size, null: false, default: 10
      t.integer :gen, null: false, default: 1

      t.timestamps
    end
  end
end
