class Speciality < ActiveRecord::Base
  has_many :events, :through => :event_specialities
  has_many :entry_specialities
  has_many :entries, :through => :entry_specialities
  has_many :event_specialities
  
  attr_accessible :Type, :eventID
  validates :Type, :presence => true, :uniqueness => true

def as_json(options = {})
    @jsonarray = []
    @jsonarrayids = []
    @event_id = self.eventID
    @check_event = false
    @event_entries = Array.new
    @contest_entries = Array.new

    if @event_id != -1
      @check_event = true      
      @event = Event.find(@event_id)      
      @contests = @event.contests
      @event_speciality = EventSpeciality.where("speciality_id = ? and event_id = ?",self.id, @event.id).first

      @contests.each do |contest|
        @contest_entries = contest.entries
        @contest_entries.each do |contest_entry|
          @event_entries.push(contest_entry.id)
        end
      end
    end

    self.entries.each do |e|
      if @check_event
        if @event_entries.include?(e.id) 
          e[:freezed] = false
          if (e.id == @event_speciality.FreezedEntry)
              e[:freezed] = true
          end
          if not @jsonarrayids.include?(e.id)
            @jsonarray.push ( e )
            @jsonarrayids.push (e.id)
          end
        end
      else
          e[:freezed] = false
          if (e.id == @event_speciality.FreezedEntry)
              e[:freezed] = true
          end
          if not @jsonarrayids.include?(e.id)
            @jsonarray.push ( e )
            @jsonarrayids.push (e.id)
          end
      end
    end

    super().merge( :entries => @jsonarray )
  end
end
