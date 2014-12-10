class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.integer :sheet_id
      t.integer :position
      t.string :heading

      t.timestamps
    end
  end
end
