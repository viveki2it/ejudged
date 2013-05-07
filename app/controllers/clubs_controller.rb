class ClubsController < ApplicationController
  # GET /clubs
  # GET /clubs.json
  def index

    @clubs = Club.all

    if not ((request.format == "json") and (not params[:page].present?))
      @clubs = Kaminari.paginate_array(@clubs).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @clubs }
    end
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
    @club = Club.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @club }
    end
  end

  # GET /clubs/new
  # GET /clubs/new.json
  def new
    @club = Club.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
  end

  # POST /clubs
  # POST /clubs.json
  def create

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    
    create_club_ok = is_admin_or_event_manager(@user)

    if create_club_ok
      @club = Club.new(params[:club])
    end

    respond_to do |format|
      if create_club_ok
        if @club.save
          format.html { redirect_to @club, :notice => 'Club was successfully created.' }
          format.json { render :json => @club, :status => :created, :location => @club }
        else
          format.html { render :action => "new" }
          format.json { render :json => @club.errors, :status => :unprocessable_entity }  
        end
      else
        format.html { redirect_to :back }
        format.json { render :json => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.json
  def update
    @club = Club.find(params[:id])

    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.html { redirect_to @club, :notice => 'Club was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to clubs_url }
      format.json { head :no_content }
    end
  end

  private
  def is_admin_or_event_manager(current_user)
    return not((current_user.roles & Role.find([1, 2])).empty?)
  end
end
