class RemovePositionFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :Position
  end

  def down
    add_column :questions, :Position, :integer
  end
end
