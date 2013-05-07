class RemoveWeightFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :Weight
  end

  def down
    add_column :questions, :Weight, :integer
  end
end
