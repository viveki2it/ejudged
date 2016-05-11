class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
     @users = User.all

    if not ((request.format == "json") and (not params[:page].present?))
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(150)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    
    create_judge_ok = is_admin_or_event_manager(@user)
    create_admin_ok = true
    first_time = (User.all.size == 0)
    #true if admin or event manager, false if judge
    if create_judge_ok or first_time
      if not params[:user][:role_ids].nil?
        @u_roles = Array.new
        @role = Array.new
        params[:user][:role_ids].each do |roleId|
          if not roleId.empty?
            @role.push(Role.find(roleId))
            @u_roles.push(roleId.to_i)
          end
        end
      end
      #if it's an event manager don't allow to create other admins
      is_admin = is_admin(@user)
      create_admin_ok = (is_admin or ((not is_admin) and (not @u_roles.include?(1))))
      if create_admin_ok or first_time
        @usr = User.new(params[:user])
        @usr.roles = @role

        if not params[:user][:event_ids].nil?
          params[:user][:event_ids].each do |eventId|
            if not eventId.empty?
              @usr.events.push Event.find eventId
            end
          end
        end

        @usr.Created = DateTime.now
        @token = @usr.tokens.new
        @token.Value = Token.generate_token
      end
    end

    respond_to do |format|
      if (create_judge_ok and create_admin_ok) or first_time
        if @usr.save
          format.html { redirect_to @usr, notice: 'User was successfully created.' }
          format.json { render json: @usr, status: :created, location: @usr }
        else
          format.html { redirect_to :back }
          format.json { render json: @usr.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to :back }
        format.json { render json: @usr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user_roles = @user.user_roles
    #Judges can't change their password
    #judge_not_ok = ((params[:user][:Password] != @user.Password) and (is_judge(@user) and (not is_admin_or_event_manager(@user))))

    #if not judge_not_ok

      if params[:user][:Password] == ""
        params[:user][:Password] = @user.Password
      end 
      
      @user_roles.each do |ur|
        ur.delete
      end

      params[:user][:role_ids].each do |roleId|
        if not roleId.empty?
          @user.roles.push Role.find roleId 
        end
      end

      @user_events = @user.user_events
      @user_events.each do |ue|
        ue.delete
      end

      params[:user][:event_ids].each do |eventId|
        if not eventId.empty?
          @user.events.push Event.find eventId 
        end
      end
    #end

    respond_to do |format|
     # if not judge_not_ok
        if @user.update_attributes(params[:user])
          format.html { redirect_to @user, :notice => 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, :status => :unprocessable_entity }
        end
       # else
       #   format.html { redirect_to :back }
       #   format.json { render json: @user.errors, :status => :unprocessable_entity }
       # end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = session[:currentUser]
    if @user.nil? and params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    end
    delete_judge_ok = is_admin_or_event_manager(@user)
    is_admin = is_admin(@user)
    delete_admin_or_em_ok = true

    if delete_judge_ok
        @user_to_delete = User.find(params[:id])

        @u_roles = Array.new
        @user_to_delete.roles.each do |ur|
          @u_roles.push(ur.id)
        end
        #if it's an event manager don't allow to delete other admins or other event managers
        delete_admin_or_em_ok = (is_admin or ((not is_admin) and (not @u_roles.include?(1)) and (not @u_roles.include?(2))))
        if delete_admin_or_em_ok
          @user_to_delete.destroy
        end
    end
   
    respond_to do |format|
      if delete_judge_ok and delete_admin_or_em_ok
        format.html { redirect_to users_url }
        format.json { head :no_content }
      else
        format.html { redirect_to :back }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def is_admin_or_event_manager(current_user)
    return not((current_user.roles & Role.find([1, 2])).empty?)
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

  def is_judge(current_user)
    @roles = current_user.roles
    @roles_ids = Array.new
    if not @roles.nil?
      @roles.each do |r|
        @roles_ids.push(r.id)
      end
    end
    return @roles_ids.include?(3)
  end

end
