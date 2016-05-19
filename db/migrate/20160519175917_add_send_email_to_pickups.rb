class AddSendEmailToPickups < ActiveRecord::Migration
  def change
    add_column :pickups, :send_email, :boolean, default: false
  end
end
