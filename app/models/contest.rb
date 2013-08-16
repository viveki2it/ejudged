class Contest < ActiveRecord::Base
  belongs_to :judge_sheet
  belongs_to :event
  belongs_to :category
  attr_accessible :ContestName, :category_id

  has_many :final_results
  has_many :entries

  validates :ContestName, :presence => true
  validates :judge_sheet_id, :event_id, :category_id, :presence => true

  def as_json(options = {})
    super(
        :include => {
          :event => {:only => [:EventName]}
        })
  end

  def full_name
  	fullName = self.ContestName
  	if self.event != nil
  		fullName = fullName + ', Event: ' + self.event.EventName
  	end
  	return fullName
  end

end
