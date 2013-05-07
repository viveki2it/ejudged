class SeriesController < ApplicationController
  # GET /series
  # GET /series.json
  def index
    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end

    if params[:Completed].present? and params[:page].present?
      if is_admin(@user)
        @series = Serie.where("Completed = ?", params[:Completed]).page(params[:page]).per(10)
      else
        @series = Serie.where("Completed = ? and id IN(?)", params[:Completed], get_user_series(@user)).page(params[:page]).per(10)
      end

    elsif params[:Completed].present?
      if is_admin(@user)
        @series = Serie.where("Completed = ?", params[:Completed])
      else
        @series = Serie.where("Completed = ? and id IN(?)", params[:Completed], get_user_series(@user))
      end

    elsif params[:page].present?
      if is_admin(@user)
        @series = Serie.page(params[:page]).per(10)
      else
        @series = Serie.where("id IN(?)", get_user_series(@user)).page(params[:page]).per(10)
      end

    else
      if is_admin(@user)
        @series = Serie.all
      else
        @series = Serie.where("id IN(?)", get_user_series(@user))
      end

    end

    if not params[:page].present? #comes from web or json and already paginate array, don't paginate again
      if not ((request.format == "json") and (not params[:page].present?)) #comes from web and ask for index then paginate array
        @series = Kaminari.paginate_array(@series).page(params[:page]).per(10)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @series }
    end
  end

  # GET /series/1
  # GET /series/1.json
  def show
    @series = Serie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @series }
    end
  end

  # GET /series/new
  # GET /series/new.json
  def new
    @series = Serie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @series }
    end
  end

  # GET /series/1/edit
  def edit
    @series = Serie.find(params[:id])
  end

  # POST /series
  # POST /series.json
  def create
    @series = Serie.new(params[:serie])
    @series.Completed = true

    respond_to do |format|
      if @series.save
        format.html { redirect_to @series, :notice => 'Serie was successfully created.' }
        format.json { render :json => @series, :status => :created, :location => @series }
      else
        format.html { render :action => "new" }
        format.json { render :json => @series.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /series/1
  # PUT /series/1.json
  def update
    @series = Serie.find(params[:id])

    respond_to do |format|
      if @series.update_attributes(params[:serie])
        format.html { redirect_to @series, :notice => 'Serie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @series.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    @series = Serie.find(params[:id])
    @series.destroy

    respond_to do |format|
      format.html { redirect_to series_url }
      format.json { head :no_content }
    end
  end

  private
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

  def get_user_series(current_user)
    @series = Array.new   
    @user_events = current_user.events

    if not @user_events.nil?
      @user_events.each do |ue|
        @series.push(ue.serie_id)
      end
    end
    return @series
  end

end
