class VoteController < ApplicationController

	def Calificate
	# if ( already rated car && ( I have rated the car || I'm admin manager || admin) ) 
		# => I can nominate!

	# if ( not reated car && !admin )
		# => I can nominate!
		begin
			@theparameters = JSON.parse(request.raw_post)
			@token = Token.where(:Value => @theparameters.fetch("token")).first

			@modified = false
			@user = @token.user
			@entry = Entry.find(@theparameters.fetch("entry_id"))
			@contest = @entry.contest
			@event_entry = @contest.event
			@completed = @event_entry.Completed
			if !@completed
				@judgeSheet = @contest.judge_sheet
				@is_new = @theparameters.fetch "is_new"

				@col_answer = Array.new
				@categories = @theparameters.fetch "map"
				@categories.keys.each do |category|
				 	@questions = @categories[category]
				 	@questions.each do |q|

				 		@questionJson = q["question"]
				 		if @questionJson != nil
					 		@question = Question.find(@questionJson["id"])
					 		@question_type = @question.question_type
					 		@answer = q["answer"]
					 		if @answer != nil 
					 			if not @answer["id"].present?
					 				if (@user.roles & Role.find([1])).empty?	#!admin
						 				@result = Result.new
						 				@result.Value = @answer["Value"]
						 				@result.entry = @entry
						 				@result.question = @question
						 				@result.user = @user
						 				@result.save
						 				@result.id

						 				@modified = true
						 				@col_answer.push(@answer)
						 			else
						 				render :json => {error:"You can't rate for this new entry because you are an admin"}, :status => :unprocessable_entity
					 					return 
						 			end					 				
					 			else
					 				@result = Result.find(@answer["id"])
					 				

					 				#if not the orignial user and not admin => can't change.
					 				if ( @user.id == @result.user.id || (not (@user.roles & Role.find([1, 2])).empty?) )
					 					if (not @question_type.nil?) and @question_type.Type != "Notes"
						 					@result.Value = @answer["Value"]
						 				else
						 					@result.Notes = @answer["Notes"]
						 				end
					 					@result.save
					 					@result = Result.find(@answer["id"])

					 					@modified = true
					 					@col_answer.push(@answer)
					 				else
					 					render :json => {error:"This entry has already been judged."}, :status => :unprocessable_entity
					 					return 
					 				end
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

							if @isNominated and (not includecar(@speciality_id,@entry.id,@user.id))
							   @entry_speciality = EntrySpeciality.new(:speciality_id => @speciality_id, :entry_id => @entry.id, :user_id => @user.id)
							   @speciality.entry_specialities.push(@entry_speciality)
							   @entry.entry_specialities.push(@entry_speciality)
							   @user.entry_specialities.push(@entry_speciality)
							   @modified = true
							elsif (not @isNominated) and includecar(@speciality_id,@entry.id,@user.id)
							   @speciality.entries.delete(@entry)
							   @modified = true
							end
							@speciality.save

						end
					else
						@event = @contest.event
						@specialities = @event.specialities

						@specialities_record = Array.new
						@specialities.each do |sp|
							@record = Hash.new
							@record["Type"] = sp.Type
							@record["id"] = sp.id
							if includecar(sp.id, @entry.id, @user.id)
								@record["isNominated"] = true
							else
								@record["isNominated"] = false
							end
							@specialities_record.push(@record)
						end
					end
				end

				if @modified 
					@entry.user = @user
          			@entry.Created = DateTime.now
          		end
				@entry.Score = TotalScore(@entry.id)
				@entry.save

	  			@return = Array.new
	  			@return.push(@col_answer,@specialities_record)
	  			render :json => @return
	  		else
	  			render :json => {error:"This event has past."}, :status => :unprocessable_entity
	  		end
  		rescue Exception => e
				render :json => {error:"couldn't find required entity", err_description: e.message}, :status => :unprocessable_entity 
		end
	end

	def getQuestionsAndAnswers
		if params[:token].present? and params[:entry_id].present?
			begin
				@token = Token.where(:Value => params[:token]).first
				@user = @token.user

				@entry = Entry.find( params[:entry_id] )
				@contest = @entry.contest
				@judgeSheet = @contest.judge_sheet
				@questions = @judgeSheet.questions

				@firstItemName = nil
				@firstItemValue = []

				@SecondItemName  = nil
				@SecondItemValue = []

				@thirdItemName  = nil
				@thirdItemValue = []

				@fourthItemName  = nil
				@fourthItemValue = []

				@lastItemName  = nil
				@lastItemValue  = []

				@returnMap = Hash.new
				@questions.each do |q|

					if (q.question_category.Name.downcase == "exterior")

						@firstItemName = q.question_category.Name
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@firstItemValue.push(@itemm)

					elsif (q.question_category.Name.downcase == "engine compartment")

						@SecondItemName = q.question_category.Name
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@SecondItemValue.push(@itemm)

					elsif (q.question_category.Name.downcase == "interior")

						@thirdItemName = q.question_category.Name
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@thirdItemValue.push(@itemm)

					elsif (q.question_category.Name.downcase == "show quality")

						@fourthItemName = q.question_category.Name
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@fourthItemValue.push(@itemm)

					elsif (q.question_category.Name.downcase == "other")

						@lastItemName = q.question_category.Name
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@lastItemValue.push(@itemm)
						
					else
						if @returnMap[q.question_category.Name].nil? and 
							@returnMap[q.question_category.Name] = []
						end
						@itemm = Hash.new
						@itemm["question"] = q
						#@itemm["answer"] = Result.where(:entry_id => @entry.id,:user_id => @user.id, :question_id => q.id).first
						@itemm["answer"] = Result.where(:entry_id => @entry.id, :question_id => q.id).first
						@returnMap[q.question_category.Name].push(@itemm)
					end
				end

#harkcoding order.
				@returnMap2 = Hash.new	

				if (@firstItemName != nil)
					@returnMap2[ @firstItemName ] = @firstItemValue;
				end

				if (@SecondItemName != nil)
					@returnMap2[ @SecondItemName ] = @SecondItemValue;
				end

				if (@thirdItemName != nil)
					@returnMap2[ @thirdItemName ] = @thirdItemValue;
				end

				if (@fourthItemName != nil)
					@returnMap2[ @fourthItemName ] = @fourthItemValue;
				end

				if (@lastItemName != nil)
					@returnMap2[ @lastItemName ] = @lastItemValue;
				end

				@returnMap2 = @returnMap2.merge(@returnMap)
#end

				#listing specialities
				@event = @contest.event
				@specialities = @event.specialities

				@specialities_record = Array.new
				@specialities.each do |sp|
					@record = Hash.new
					@record["Type"] = sp.Type
					@record["id"] = sp.id
					if includecar(sp.id, @entry.id, @user.id)
						@record["isNominated"] = true
					else
						@record["isNominated"] = false
					end
					@specialities_record.push(@record)
				end
				@returnMapSp = Hash.new
				@returnMapSp["Specialities"] = @specialities_record
				@return = Array.new
				@return.push(@returnMap2, @returnMapSp)
				
				respond_to do |format|
					format.json { render :json => @return}
				end
			rescue Exception => e
				render :json => {error:"couldn't find required entity", err_description: e.message}, :status => :unprocessable_entity 
			end
		else
			render :json => {error:"couldn't find required parameters"}, :status => :bad_request
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

  	def includecar(speciality_id, entry_id, user_id)
  		return EntrySpeciality.where("speciality_id = ? and entry_id = ? and user_id = ? ", speciality_id, entry_id, user_id ).size > 0
  	end
end