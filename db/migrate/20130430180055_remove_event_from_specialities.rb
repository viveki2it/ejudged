class RemoveEventFromSpecialities < ActiveRecord::Migration
  def up
    remove_column :specialities, :event_id
  end

  def down
    add_column :specialities, :event_id, :references
  end
end
