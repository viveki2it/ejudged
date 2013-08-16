class Company < ActiveRecord::Base
  attr_accessible :Name, :presence => true
  has_many :csv_uploads, :dependent => :destroy
  has_many :customers
  has_many :entries

  validates :Name, :uniqueness => true
end
