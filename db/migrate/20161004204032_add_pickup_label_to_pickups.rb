class AddPickupLabelToPickups < ActiveRecord::Migration[4.2]
  def change
    add_column :pickups, :pickup_label, :string
    add_column :pickups, :pickup_label_color, :string
  end
end
