class Serie < ActiveRecord::Base
  attr_accessible :Completed, :SeriesName

  has_many :events, :dependent => :destroy

  validates :SeriesName, :presence => true, :uniqueness => true

end
