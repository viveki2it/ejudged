class QuestionCategory < ActiveRecord::Base
  attr_accessible :Name, :position_number
  has_many :questions, :dependent => :destroy

  validates :Name, :presence => true, :uniqueness => true
end
