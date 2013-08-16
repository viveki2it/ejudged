class Entry < ActiveRecord::Base
  belongs_to :contest
  belongs_to :club
  belongs_to :customer
  belongs_to :user
  belongs_to :company
  
  has_many :results, :dependent => :destroy
  has_many :entry_specialities
  has_many :specialities, :through => :entry_specialities
  has_many :photos, :dependent => :destroy 

  attr_accessible :RegistrationType,:Freezed, :Make, :Model, :Notes, :RegistrationNumber, :Score, :Year, :photos_attributes
  
  validates :Make, :Model, :Year,:RegistrationNumber, :presence => true
  validates :RegistrationNumber, :numericality => true

  def serializable_hash(options = {})
    super(
        :include => {
          :photos => {},:customer => {}, :user => {}
        })
  end

  def full_name
    if (self.Make != nil) and (self.Model != nil) and (self.Year != nil)
      return  self.Make + ' ' + self.Model + ' ' + self.Year
    else
      return ' '
    end
  end

end
