class AddDayNotesToDays < ActiveRecord::Migration
  def change
    add_column :days, :day_notes, :text
  end
end
