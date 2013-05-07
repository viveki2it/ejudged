class RemoveIncludeInTotalFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :IncludeInTotal
  end

  def down
    add_column :questions, :IncludeInTotal, :boolean
  end
end
