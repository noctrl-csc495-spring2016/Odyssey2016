class AddSendEmailToPickups < ActiveRecord::Migration[4.2]
  def change
    add_column :pickups, :send_email, :boolean, default: false
  end
end
