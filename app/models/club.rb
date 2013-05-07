class Club < ActiveRecord::Base
  attr_accessible :ClubName
  has_many :entries
  has_many :customers
  
  validates :ClubName, :presence => true, :uniqueness => true
end
