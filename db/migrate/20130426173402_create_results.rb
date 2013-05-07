class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :Value
      t.string :Notes
      t.references :entry
      t.references :question
      t.references :user

      t.timestamps
    end
    add_index :results, :entry_id
    add_index :results, :question_id
    add_index :results, :user_id
  end
end
