class Question < ActiveRecord::Base
	
  belongs_to :question_category
  belongs_to :question_type
  belongs_to :judge_sheet
  has_many :results
  attr_accessible :MaxVal, :MinVal, :QuestionDescrip, :QuestionText

  validates :question_type_id, :question_category_id, :judge_sheet_id, :MinVal, :MaxVal, :QuestionText, :presence => true
  validates :MinVal, :MaxVal, :numericality => true
end
