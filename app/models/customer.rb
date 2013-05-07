class Customer < ActiveRecord::Base
  belongs_to :club
  belongs_to :contact_info
  has_many :entries, :dependent => :destroy
  validates :club_id, :contact_info_id, :presence => true

  def serializable_hash(options = {})
    super(
        :include => {
          :contact_info => {:only => [:FirstName, :LastName]}
        })
  end

  def full_name
    return self.contact_info.FirstName + ' ' + self.contact_info.LastName
  end
end
