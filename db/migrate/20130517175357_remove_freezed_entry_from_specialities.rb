class RemoveFreezedEntryFromSpecialities < ActiveRecord::Migration
  def up
    remove_column :specialities, :FreezedEntry
  end

  def down
    add_column :specialities, :FreezedEntry, :integer
  end
end
