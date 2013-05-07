class CreateEventSpecialities < ActiveRecord::Migration
  def change
    create_table :event_specialities do |t|
      t.references :event
      t.references :speciality

      t.timestamps
    end
    add_index :event_specialities, :event_id
    add_index :event_specialities, :speciality_id
  end
end
