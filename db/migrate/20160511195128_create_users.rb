class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :username
      t.integer :permission_level, :default => 0
      t.boolean :super_admin, :default => false

      t.timestamps null: false
    end
  end
end
