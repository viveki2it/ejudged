class EventSpeciality < ActiveRecord::Base
  belongs_to :event
  belongs_to :speciality
end
