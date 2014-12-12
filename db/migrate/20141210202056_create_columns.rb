class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.integer :sheet_id
      t.integer :position
      t.string  :header

      t.string  :formula

      t.string  :content_type

      t.string  :selector_class
      t.string  :selector_method

      t.timestamps
    end
  end
end
