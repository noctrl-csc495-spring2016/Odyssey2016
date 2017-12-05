class AddDayNotesToDays < ActiveRecord::Migration[4.2]
  def change
    add_column :days, :day_notes, :text
  end
end
