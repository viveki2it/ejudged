class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :contests

  validates :name, :presence => true, :uniqueness => true
end
