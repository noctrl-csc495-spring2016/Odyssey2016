class CreatePickups < ActiveRecord::Migration[4.2]
  def change
    create_table :pickups do |t|
      t.integer :day_id
      t.string :donor_title
      t.string :donor_first_name
      t.string :donor_last_name
      t.string :donor_spouse_name
      t.string :donor_address_line1
      t.string :donor_address_line2
      t.string :donor_city
      t.string :donor_zip
      t.string :donor_dwelling_type
      t.string :donor_phone
      t.string :donor_email
      t.integer :number_of_items
      t.text :item_notes
      t.text :donor_notes
      t.boolean :rejected, :default => false
      t.string :rejected_reason

      t.timestamps null: false
    end
  end
end
