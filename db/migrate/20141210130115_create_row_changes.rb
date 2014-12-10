class CreateRowChanges < ActiveRecord::Migration
  def change
    create_table :row_changes do |t|
      t.integer :row_id
      t.text :json

      t.timestamps
    end
  end
end
