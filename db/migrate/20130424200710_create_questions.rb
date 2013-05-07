class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :QuestionText
      t.boolean :Required
      t.integer :MinVal
      t.integer :MaxVal
      t.boolean :IncludeInTotal
      t.boolean :JudgesOnly
      t.boolean :OrganizersOnly
      t.integer :Position
      t.integer :Weight
      t.string :QuestionDescrip
      t.references :question_category
      t.references :question_type
      t.references :judge_sheet

      t.timestamps
    end
    add_index :questions, :question_category_id
    add_index :questions, :question_type_id
    add_index :questions, :judge_sheet_id
  end
end
