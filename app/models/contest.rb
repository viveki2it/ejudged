class Contest < ActiveRecord::Base
  belongs_to :judge_sheet
  belongs_to :event
  belongs_to :category
  attr_accessible :ContestName, :category_id

  has_many :final_results
  has_many :entries

  validates :ContestName, :presence => true, :uniqueness => true
  validates :judge_sheet_id, :event_id, :category_id, :presence => true
end
