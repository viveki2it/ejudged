class AddPositionNumberToQuestionCategories < ActiveRecord::Migration
  def change
    add_column :question_categories, :position_number, :integer
  end
end
