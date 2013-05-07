class QuestionCategory < ActiveRecord::Base
  attr_accessible :Name
  has_many :questions, :dependent => :destroy

  validates :Name, :presence => true, :uniqueness => true
end
