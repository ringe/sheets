class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :name

      t.timestamps
    end
  end
end
