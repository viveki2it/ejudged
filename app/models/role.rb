class Role < ActiveRecord::Base
  attr_accessible :RoleName, :id 
#  has_many :user_roles
#  has_many :users, :through => :user_roles
end
