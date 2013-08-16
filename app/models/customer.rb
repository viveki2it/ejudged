class Customer < ActiveRecord::Base
  belongs_to :club
  belongs_to :contact_info
  belongs_to :company
  has_many :entries, :dependent => :destroy
  #validates :club_id, :contact_info_id, :presence => true
  attr_accessible :external_id


  def serializable_hash(options = {})
    super(
        :include => {
          :contact_info => {:only => [:FirstName, :LastName]}
        })
  end

  def full_name
    if self.contact_info != nil
      if (self.contact_info.FirstName != nil) and (self.contact_info.LastName != nil) 
        return self.contact_info.FirstName + ' ' + self.contact_info.LastName
      else
        return ' '
      end
    else
      return ' '
    end
  end
end
