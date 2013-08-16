class NewRegistrationController < ApplicationController

	def addCar

		begin
			@customerNew = false
			@bad_request = false
			@theparameters = JSON.parse(request.raw_post)
			@token = Token.where(:Value => @theparameters.fetch("token")).first
			@user = @token.user

			#create a club if none has been chosen
			if @theparameters.keys.include?("ClubName")
				@club = Club.new(:ClubName => @theparameters.fetch("ClubName"))
				@club.save
				#flush clubs
				Club.all

			elsif @theparameters.keys.include?("club_id")
				  @club = Club.find(@theparameters.fetch("club_id"))

			else
				@bad_request = true					
			end

			if not @bad_request
				#create a customer if none has been chosen
				if (@theparameters.keys.include?("customer_id"))
					@customer =  Customer.find(@theparameters.fetch("customer_id"))
					@customerOK = true

				elsif @theparameters.keys.include?("FirstName") and @theparameters.keys.include?("LastName")
					@contact_info = ContactInfo.new(:FirstName => @theparameters.fetch("FirstName"), :LastName => @theparameters.fetch("LastName"))
					@contact_info.save
					#flush contact info
					ContactInfo.all
					@customer = Customer.new
					@customer.contact_info = @contact_info	
					@customer.club = @club
					@customer.save
					#flush customer
					Customer.all
					@customerNew = true
				else
					@bad_request = true					
				end
			end

			if not @bad_request
				#create entry
				if @theparameters.keys.include?("contest_id") and @theparameters.keys.include?("RegistrationNumber") and @theparameters.keys.include?("Year") and @theparameters.keys.include?("Make") and @theparameters.keys.include?("Model")
					@entry = Entry.new(:RegistrationNumber => @theparameters.fetch("RegistrationNumber"), :Year => @theparameters.fetch("Year"), :Make => @theparameters.fetch("Make"), :Model => @theparameters.fetch("Model"), :Score => 0)
					@contest = Contest.find(@theparameters.fetch("contest_id"))
					@entry.contest = @contest
					@entry.RegistrationType = "Mobile Registration"
					if @customerNew
						@entry.club = @club
					else
						@entry.club = @customer.club
					end

					################################ added for offline mode #####################
					if @theparameters.keys.include?("photo")
						@photo = Photo.new(:photo => @theparameters.fetch("photo"))
            			@photo.save
           				@entry.photos.push(@photo)					
					end

					##########################
					@entry.customer = @customer
					@entry.save
					##########################

					@modified = false
					@event_entry = @contest.event
					@completed = @event_entry.Completed
					if !@completed
						@judgeSheet = @contest.judge_sheet

						#@col_answer = Array.new
						if @theparameters.include?("map")
							@categories = @theparameters.fetch("map")						
							@categories.keys.each do |category|
							 	@questions = @categories[category]
							 	@questions.each do |q|

							 		@questionJson = q["question"]
							 		if @questionJson != nil
								 		@question = Question.find(@questionJson["id"])
								 		@question_type = @question.question_type
								 		@answer = q["answer"]
								 		if @answer != nil 
								 			#if not @answer["id"].present?
								 				if (@user.roles & Role.find([1])).empty?# and @entry.results.size == 0 #!admin
									 				@result = Result.new
									 				
									 				if (not @question_type.nil?) and (@question_type.Type != "Notes")
									 					@result.Value = @answer["Value"]
									 				else
									 					@result.Notes = @answer["Notes"]
									 				end
									 				
									 				@result.entry = @entry
									 				@result.question = @question
									 				@result.user = @user
									 				@result.save

									 				@modified = true
									 				#@col_answer.push(@answer)
									 			else
									 				render :json => {error:"You can't rate for this new entry because you are an admin", :entry => @entry }, :status => :unprocessable_entity
								 					return 
								 					#@bad_request = true
									 			end					 				
								 			# else
								 			# 	@result = Result.find(@answer["id"])
								 				

								 			# 	#if not the orignial user and not admin => can't change.
								 			# 	if ( @user.id == @result.user.id || (not (@user.roles & Role.find([1, 2])).empty?) )
								 			# 		if (not @question_type.nil?) and (@question_type.Type != "Notes")
									 		# 			@result.Value = @answer["Value"]
									 		# 		else
									 		# 			@result.Notes = @answer["Notes"]
									 		# 		end
									 		# 		@result.user = @user
								 			# 		@result.save
								 			# 		@result = Result.find(@answer["id"])

								 			# 		@modified = true
								 			# 		#@col_answer.push(@answer)
								 			# 	else
								 			# 		render :json => {error:"This entry has already been judged.", :entry => @entry } ,:status => :unprocessable_entity
								 			# 		return
								 			# 		#@bad_request = true 
								 			# 	end
								 			# end
								 		end
								 	end
							 	end
							end
						end

						#saving specialities nominations
						if @theparameters.keys.include?("Specialities")
							@specialities_record = @theparameters.fetch("Specialities")
							if @specialities_record.size > 0
								@specialities_record.each do |sp|
									@speciality_id = sp["id"]
									@isNominated = sp["isNominated"]
									@speciality = Speciality.find(@speciality_id)

									if @isNominated #and (not includecar(@speciality_id,@entry.id,@user.id))
									   @entry_speciality = EntrySpeciality.new(:speciality_id => @speciality_id, :entry_id => @entry.id, :user_id => @user.id)
									   @speciality.entry_specialities.push(@entry_speciality)
									   @entry.entry_specialities.push(@entry_speciality)
									   @user.entry_specialities.push(@entry_speciality)
									   @modified = true
									# elsif (not @isNominated) and includecar(@speciality_id,@entry.id,@user.id)
									#    @speciality.entries.delete(@entry)
									#    @modified = true
									end
									@speciality.save

								end
							# else
							# 	@event = @contest.event
							# 	@specialities = @event.specialities

							# 	#@specialities_record = Array.new
							# 	@specialities.each do |sp|
							# 		@record = Hash.new
							# 		@record["Type"] = sp.Type
							# 		@record["id"] = sp.id
							# 		if includecar(sp.id, @entry.id, @user.id)
							# 			@record["isNominated"] = true
							# 		else
							# 			@record["isNominated"] = false
							# 		end
							# 		#@specialities_record.push(@record)
							# 	end
							end
						end

						if @modified 
							@entry.user = @user
		          			@entry.Created = DateTime.now
		          		end
						@entry.Score = TotalScore(@entry.id)
						@entry.save

			  			#@return = Array.new

			  			#@return.push(@col_answer,@specialities_record, @entry)
			  			#render :json => @return

			  		else
			  			render :json => {error:"This event has past.", :entry => @entry }, :status => :unprocessable_entity
						return
			  			#@bad_request = true
			  		end
			  		###################################################################					

					#return statement if everything it's ok
					render :json => @entry

				else
					@bad_request = true	
				end
			end

			if @bad_request 
				render :json => {error:"couldn't find required parameters"}, :status => :bad_request
			end

		rescue Exception => e
			render :json => {error:"couldn't find required entity", err_description: e.message}, :status => :unprocessable_entity 
		end
	end

	def TotalScore (entryId)
	    @results = Result.where("entry_id = ?", entryId)
	    @total = 0
	    @results.each do |r|
	   	  if r.Value != nil
	      	@total = @total + r.Value
	      end
	    end
    	return @total
  	end

end
