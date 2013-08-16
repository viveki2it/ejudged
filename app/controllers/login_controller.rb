class LoginController < ApplicationController

skip_before_filter :require_login, :only => [:new, :create,:login,:authenticate,:index]

	def index
		@user = User.new

		respond_to do |format|
		  format.html 
		  format.json { render :json => @user }
		end
	end

	#this is a login for webservices, if website then redirect.
	def login
	  	@userr = User.where(["name = ? and password = ?", params[:name],params[:password]]).first

	  	if not @userr.nil?

	  		if not (@userr.roles & Role.find([1, 2])).empty?
	  			@token = @userr.tokens.last
	  			@result = [@userr, @token]
	  			render :json => @result
	  			
	  		elsif not @userr.events.select{ |ev| not ev.Completed and ev.EventDate.to_date + 2 >= Date.today}.empty?
	  			@token = @userr.tokens.last
	  			@result = [@userr, @token]
	  			render :json => @result
	  		else
	  			render :json => {error:"There are no events currently active for this user."}, :status => :unauthorized
	  		end
  		else

  			respond_to do |format|
      			format.html { redirect_to '/login/index' }
      			format.json { render :json => {error:"Invalid username or password please try again."}, :status => :unprocessable_entity  }
    		end
		end
	end

	#this is a login for website, webservices authentication is different.
	def authenticate
		@authenticatedUser = User.where(:name => params[:user][:Name],:password => params[:user][:Password]).first

		@user = User.new(params[:user])
		first_time = false

		if (User.all.size == 0) && @authenticatedUser.nil? && params[:user][:Name] == "admin" && params[:user][:Password] == "admin"
	  		@authenticatedUser = User.new
	  		first_time = true
	  	end

	  	if (not @authenticatedUser.nil?) or first_time
			login_ok = is_admin(@authenticatedUser)
		
			if login_ok or first_time
				session[:currentUser] = @authenticatedUser
				redirect_to :action => "home"
			else
				redirect_to '/login/index', :notice => 'Invalid username or password please try again.'
			end
		else
			redirect_to '/login/index', :notice => 'Invalid username or password please try again.'
		end
	end

	def home
	end

	def logout
		session[:currentUser] = nil
		redirect_to '/login/index', :notice => 'You have been logged out.'
	end

    def is_admin(current_user)
      @roles = current_user.roles
      @roles_ids = Array.new
      if not @roles.nil?
        @roles.each do |r|
          @roles_ids.push(r.id)
        end
      end
      return @roles_ids.include?(1)
    end

end