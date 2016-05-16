class AddDonorStateToPickups < ActiveRecord::Migration
  def change
    add_column :pickups, :donor_state, :string
  end
end
