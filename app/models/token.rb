class Token < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ExpirationDate, :Value

	def self.generate_token
		loop do
		  random_token = SecureRandom.urlsafe_base64
		  break random_token unless Token.where(Value: random_token).exists?
		end
	end
end