class Result < ActiveRecord::Base
  belongs_to :entry
  belongs_to :question
  belongs_to :user
  attr_accessible :Value, :Notes

  validates :Value, :numericality => true, :allow_nil => true
  validates :entry_id, :user_id, :question_id, :presence => true
  validates :user_id, :uniqueness => { :scope => [:question_id, :entry_id], :message => "already calificate for the same question and entry" }
end
