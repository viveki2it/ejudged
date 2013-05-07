class QuestionType < ActiveRecord::Base
  attr_accessible :Type
  validates :Type, :presence => true
end
