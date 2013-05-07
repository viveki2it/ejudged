class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :club
      t.references :contact_info

      t.timestamps
    end
    add_index :customers, :club_id
    add_index :customers, :contact_info_id
  end
end
