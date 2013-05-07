class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :EventName, :default => "", :null => false
      t.string :Location, :default => "", :null => false
      t.integer :MainContactID
      t.boolean :Completed
      t.datetime :EventDate
      t.references :serie

      t.timestamps
    end
    add_index :events, :serie_id
  end
end
