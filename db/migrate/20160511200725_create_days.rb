class CreateDays < ActiveRecord::Migration[4.2]
  def change
    create_table :days do |t|
      t.date :date, :null => false

      t.timestamps null: false
    end
  end
end
