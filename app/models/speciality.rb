class Speciality < ActiveRecord::Base
  has_many :events, :through => :event_specialities
  has_many :entry_specialities
  has_many :entries, :through => :entry_specialities
  has_many :event_specialities
  
  attr_accessible :FreezedEntry, :Type
  validates :Type, :presence => true, :uniqueness => true

def as_json(options = {})
    @jsonarray = []
    @jsonarrayids = []
    self.entries.each do |e|
      e[:freezed] = false
      if (e.id == self.FreezedEntry)
          e[:freezed] = true
      end
      if not @jsonarrayids.include?(e.id)
        @jsonarray.push ( e )
        @jsonarrayids.push (e.id)
      end
    end

    super().merge( :entries => @jsonarray )
  end
end
