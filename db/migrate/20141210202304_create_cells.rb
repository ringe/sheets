class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :row_id
      t.integer :column_id
      t.string  :content

      t.timestamps
    end
  end
end
