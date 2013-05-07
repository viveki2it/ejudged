class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :ClubName, :limit => 128, :default => "", :null => false

      t.timestamps
    end
  end
end
