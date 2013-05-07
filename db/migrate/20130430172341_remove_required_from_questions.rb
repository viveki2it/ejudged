class RemoveRequiredFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :Required
  end

  def down
    add_column :questions, :Required, :boolean
  end
end
