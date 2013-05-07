class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :ContestName
      t.references :judge_sheet
      t.references :event
      t.references :category

      t.timestamps
    end
    add_index :contests, :judge_sheet_id
    add_index :contests, :event_id
    add_index :contests, :category_id
  end
end
