class User < ActiveRecord::Base
  belongs_to :contact_info
  attr_accessible :Created, :Name, :Password,:contact_info_id

  has_many :entry_specialities
  has_many :entries

  has_many :user_roles, :dependent => :destroy
  has_many :user_events, :dependent => :destroy

  has_many :events, :through => :user_events
  has_many :roles, :through => :user_roles
  
  has_many :results, :dependent => :destroy
  has_many :tokens, :dependent => :destroy

  validates :Name, :Password, :presence => true
  validates :Name, :uniqueness => true
  validates :contact_info_id, :presence => true

  def as_json(options = {})
    super(
        :include => {
          :roles => {:only => [:RoleName,:id]}
        })
  end

end
