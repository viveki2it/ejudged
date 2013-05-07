class RemoveJudgesOnlyFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :JudgesOnly
  end

  def down
    add_column :questions, :JudgesOnly, :boolean
  end
end
