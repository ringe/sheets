class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.integer :sheet_id
      t.integer :position
      t.string :heading

      t.timestamps
    end
  end
end
