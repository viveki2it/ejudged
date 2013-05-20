class EventSpeciality < ActiveRecord::Base
  belongs_to :event
  belongs_to :speciality
  attr_accessible :FreezedEntry


  def getEntriesEvent()
  	@event = self.event
  	@result = Array.new
  	if @event != nil
  		@contests = @event.contests
  		@contests.each do |contest|
  			@entries = contest.entries
  			@entries.each do |entry|
  				@result.push(entry.id)
  			end
  		end
  	end
  	return @result
  end

end
