class ContactInfo < ActiveRecord::Base
  attr_accessible :id, :Address1, :Address2, :Address3, :AltPhone, :City, :Email, :FirstName, :LastName, :MiddleInitial, :Phone, :State, :ZipCode
  has_one :customer
  has_many :users

  validates :FirstName, :LastName, :presence => true
  
  def full_name
    return self.FirstName + ' ' + self.LastName
  end

end
