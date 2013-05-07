class ApplicationController < ActionController::Base
  protect_from_forgery

   before_filter :require_login

   private
 
  def require_login
    begin
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to :controller => "login", :action => "login" 
      end
    rescue Exception => e
      render :json => {error:"unauthorized token", err_description: e.message} , :status => :unauthorized 
    end
  end
 
  # The logged_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  # Note that this is not common in Ruby and is discouraged unless you
  # really mean to convert something into true or false.
  def logged_in?
  	respond_to do |format|
	    format.html { session[:currentUser].present? } 
	    format.json {

          begin
            if (not params[:token].nil?)
              @token = Token.where(:Value => params[:token]).first
            else
              @theparameters = JSON.parse(request.raw_post)
              @token = Token.where(:Value => @theparameters.fetch("token")).first
            end
            @userr = @token.user

            if is_admin(@userr)
              return true
              
            elsif not @userr.events.select{ |ev| not ev.Completed and ev.EventDate + 2 >= Date.today}.empty?
              return true
            else
              raise Exception, "Any event is available for this user"
            end
          rescue Exception => e
              raise Exception, "can't find the user"
          end
      }
	  end
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
