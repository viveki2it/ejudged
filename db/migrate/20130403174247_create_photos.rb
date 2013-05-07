class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :entry

      t.timestamps
    end
    add_index :photos, :entry_id
  end
end
