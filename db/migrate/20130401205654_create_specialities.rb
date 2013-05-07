class CreateSpecialities < ActiveRecord::Migration
  def change
    create_table :specialities do |t|
      t.string :Type
      t.integer :FreezedEntry
      t.references :event

      t.timestamps
    end
    add_index :specialities, :event_id
  end
end
