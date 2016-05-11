class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date, :null => false

      t.timestamps null: false
    end
  end
end
