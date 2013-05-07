class NewRegistrationController < ApplicationController

	def addCar

		begin
			@customerNew = false
			@customerOK = false
			@theparameters = JSON.parse(request.raw_post)
			@token = Token.where(:Value => @theparameters.fetch("token")).first
			@user = @token.user
			create_ok = not((@user.roles & Role.find([1, 2])).empty?)
			if create_ok
				if not (@theparameters.keys.include?("customer_id"))
					#create a customer first
					if @theparameters.keys.include?("FirstName") and @theparameters.keys.include?("LastName") and @theparameters.keys.include?("club_id")
						@contact_info = ContactInfo.new(:FirstName => @theparameters.fetch("FirstName"), :LastName => @theparameters.fetch("LastName"))
						@contact_info.save
						@customer = Customer.new
						@customer.contact_info = @contact_info
						@club = Club.find(@theparameters.fetch("club_id"))
						@customer.club = @club
						@customer.save
						@customerNew = true
						@customerOK = true
					end

				else
					@customer =  Customer.find(@theparameters.fetch("customer_id"))
					@customerOK = true
				end
				#create entry
				if @customerOK and @theparameters.keys.include?("contest_id") and @theparameters.keys.include?("RegistrationNumber") and @theparameters.keys.include?("Year") and @theparameters.keys.include?("Make") and @theparameters.keys.include?("Model")
					@entry = Entry.new(:RegistrationNumber => @theparameters.fetch("RegistrationNumber"), :Year => @theparameters.fetch("Year"), :Make => @theparameters.fetch("Make"), :Model => @theparameters.fetch("Model"))
					@entry.user = @user
					@entry.contest = Contest.find(@theparameters.fetch("contest_id"))
					if @customerNew
						@entry.club = @club
					else
						@entry.club = @customer.club
					end
					#@entry.Created = DateTime.now
					@entry.customer = @customer
					@entry.save
					render :json => @entry
				else
					render :json => {error:"couldn't find required parameters"}, :status => :bad_request
				end
			else
				render :json => {error:"permission denied"}, :status => :bad_request
			end

		rescue Exception => e
			render :json => {error:"couldn't find required entity", err_description: e.message}, :status => :unprocessable_entity 
		end
	end
end
