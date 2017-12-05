class AddDonorStateToPickups < ActiveRecord::Migration[4.2]
  def change
    add_column :pickups, :donor_state, :string
  end
end
