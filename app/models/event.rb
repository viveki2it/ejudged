class Event < ActiveRecord::Base
  belongs_to :serie
  attr_accessible :Completed, :EventName, :Location, :EventDate ,:MainContactID

  has_many :contests, :dependent => :destroy
  has_many :users, :through => :UserEvent 
  has_many :specialities, :through => :event_specialities
  has_many :event_specialities
  
  validates :serie_id, :EventName, :Location, :presence => true
  validates :EventName, :uniqueness => true

end
