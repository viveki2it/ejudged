class EntrySpeciality < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  belongs_to :speciality
end
