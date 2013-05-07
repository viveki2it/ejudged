class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :RegistrationType
      t.string :Make
      t.string :Model
      t.text :Notes
      t.integer :RegistrationNumber
      t.integer :Score
      t.string :Year
      t.references :contest
      t.references :club
      t.references :customer
      t.references :user
      t.datetime :Created

      t.timestamps
    end
    add_index :entries, :contest_id
    add_index :entries, :club_id
    add_index :entries, :customer_id
    add_index :entries, :user_id
  end
end
