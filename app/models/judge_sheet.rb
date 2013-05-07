class JudgeSheet < ActiveRecord::Base
  attr_accessible :Name
  has_many :contests
  has_many :questions

  validates :Name, :presence => true, :uniqueness => true
end
