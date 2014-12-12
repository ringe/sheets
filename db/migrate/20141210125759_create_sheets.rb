class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :name
      t.boolean :use_column_headers
      t.boolean :use_row_headers

      t.timestamps
    end
  end
end
