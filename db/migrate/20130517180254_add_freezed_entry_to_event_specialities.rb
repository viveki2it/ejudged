class AddFreezedEntryToEventSpecialities < ActiveRecord::Migration
  def change
    add_column :event_specialities, :FreezedEntry, :integer
  end
end
