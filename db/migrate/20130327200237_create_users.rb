class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :Name
      t.string :Password
      t.datetime :Created
      t.references :contact_info

      t.timestamps
    end
    add_index :users, :contact_info_id
  end
end
