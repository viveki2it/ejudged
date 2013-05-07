class CreateEntrySpecialities < ActiveRecord::Migration
  def change
    create_table :entry_specialities do |t|
      t.references :user
      t.references :entry
      t.references :speciality

      t.timestamps
    end
    add_index :entry_specialities, :user_id
    add_index :entry_specialities, :entry_id
    add_index :entry_specialities, :speciality_id
  end
end
